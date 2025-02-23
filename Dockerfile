FROM python:3.9-slim

WORKDIR /app

# 시스템 종속성 설치
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Cloud Run에서 사용하는 포트 환경 변수 반영
ENV PORT=8080
EXPOSE $PORT

# Flask 앱 실행 시 $PORT 사용
CMD ["python", "app.py"]
