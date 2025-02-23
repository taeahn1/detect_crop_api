from flask import Flask, request, jsonify, url_for
import os
from utils.pill_detection import detect_pills_and_crop

app = Flask(__name__)

# 디렉토리 설정
UPLOAD_DIR = "static/uploads"
CROPPED_DIR = "static/cropped"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(CROPPED_DIR, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400

    # 원본 이미지 저장
    image_path = os.path.join(UPLOAD_DIR, file.filename)
    file.save(image_path)

    # 알약 검출 및 크롭
    cropped_image_paths = detect_pills_and_crop(image_path, CROPPED_DIR)
    if not cropped_image_paths:
        return jsonify({"error": "No pills detected"}), 404

    # 다운로드 링크 생성
    download_links = []
    for orig_path, black_path in cropped_image_paths:
        orig_url = url_for('static', filename=os.path.relpath(orig_path, 'static'), _external=True)
        black_url = url_for('static', filename=os.path.relpath(black_path, 'static'), _external=True)
        download_links.append({"original": orig_url, "black_background": black_url})

    return jsonify({"download_links": download_links}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)