FROM python:3.9-slim

WORKDIR /app

# 시스템 종속성 설치
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY namepill-22uagc-firebase-adminsdk-fbsvc-9fd2d1687f.json .
COPY . .

ENV GOOGLE_APPLICATION_CREDENTIALS=/app/namepill-22uagc-firebase-adminsdk-fbsvc-9fd2d1687f.json
ENV ROBOFLOW_API_KEY="865VuGn7RK8dUaByjfwa"

# Cloud Run에서 사용하는 포트 환경 변수 반영
ENV PORT=8080
EXPOSE $PORT

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "120"]
