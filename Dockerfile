FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 환경 변수 설정
ENV ROBOFLOW_API_KEY="865VuGn7RK8dUaByjfwa"
ENV FIREBASE_CREDENTIALS="base64로 인코딩된 서비스 계정 JSON 문자열"

EXPOSE 8080

CMD ["python", "app.py"]