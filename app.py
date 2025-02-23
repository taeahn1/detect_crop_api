from flask import Flask, request, jsonify
import os
from utils.pill_detection import detect_pills_and_crop

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400

    user_id = request.form.get('user_id')
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    temp_path = f"/tmp/{file.filename}"
    file.save(temp_path)

    cropped_image_urls = detect_pills_and_crop(temp_path, user_id)
    os.remove(temp_path)

    if not cropped_image_urls:
        return jsonify({"error": "No pills detected"}), 404

    download_links = [
        {"original": orig_url, "black_background": black_url}
        for orig_url, black_url in cropped_image_urls
    ]

    return jsonify({"download_links": download_links}), 200

if __name__ == '__main__':
    port = int(os.getenv("PORT", 8080))  # Cloud Run의 $PORT 사용, 기본값 8080
    app.run(host='0.0.0.0', port=port)
