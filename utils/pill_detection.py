import base64
import json
import os
import cv2
import numpy as np
from inference_sdk import InferenceHTTPClient
import firebase_admin
from firebase_admin import credentials, storage

# Firebase 초기화
if not firebase_admin._apps:
    options = {'storageBucket': 'namepill-22uagc.appspot.com'}
    firebase_admin.initialize_app(options=options)
bucket = storage.bucket('namepill-22uagc.appspot.com')


# Roboflow Client 설정
CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key=os.getenv("ROBOFLOW_API_KEY")
)

CONFIDENCE_THRESHOLD = 0.3

def preprocess_image(original_image_path, cropped_filename, bbox, user_id):
    img = cv2.imread(original_image_path)
    masked_image = np.zeros_like(img)
    x1, y1, x2, y2 = bbox
    masked_image[y1:y2, x1:x2] = img[y1:y2, x1:x2]
    
    # 검은 배경 이미지 임시 저장
    temp_path = f"/tmp/{cropped_filename.replace('_original', '_black')}"
    cv2.imwrite(temp_path, masked_image)
    
    # Firebase Storage에 업로드
    blob_path = f"users/{user_id}/{cropped_filename.replace('_original', '_black')}"
    blob = bucket.blob(blob_path)
    blob.upload_from_filename(temp_path)
    blob.make_public()  # 공개 URL 생성
    os.remove(temp_path)  # 임시 파일 삭제
    
    return blob.public_url

def detect_pills_and_crop(image_path, user_id):
    try:
        result = CLIENT.infer(image_path, model_id="pilldection/1")
        predictions = result.get('predictions', [])
        
        original_image = cv2.imread(image_path)
        height, width, _ = original_image.shape

        if not predictions:
            print(f"No pills detected in: {image_path}")
            return []

        print(f"Detected {len(predictions)} pills")
        cropped_image_urls = []

        for i, prediction in enumerate(predictions, start=1):
            if prediction['confidence'] < CONFIDENCE_THRESHOLD:
                continue

            x, y, box_width, box_height = prediction['x'], prediction['y'], prediction['width'], prediction['height']
            x1, y1 = int(x - box_width / 2), int(y - box_height / 2)
            x2, y2 = int(x + box_width / 2), int(y + box_height / 2)

            x1, y1, x2, y2 = max(0, x1), max(0, y1), min(width, x2), min(height, y2)

            # 원본 크롭 이미지 임시 저장
            original_cropped_filename = f"pill_{i}_original.png"
            temp_path = f"/tmp/{original_cropped_filename}"
            cropped_image = original_image[y1:y2, x1:x2]
            cv2.imwrite(temp_path, cropped_image)

            # Firebase Storage에 업로드
            blob_path = f"users/{user_id}/{original_cropped_filename}"
            blob = bucket.blob(blob_path)
            blob.upload_from_filename(temp_path)
            blob.make_public()
            original_url = blob.public_url

            # 검은 배경 이미지 처리
            black_url = preprocess_image(image_path, original_cropped_filename, (x1, y1, x2, y2), user_id)
            
            cropped_image_urls.append((original_url, black_url))
            os.remove(temp_path)  # 임시 파일 삭제

        return cropped_image_urls

    except Exception as e:
        print(f"Error detecting pills: {e}")
        return []
