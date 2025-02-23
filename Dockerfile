FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 환경 변수 설정
ENV ROBOFLOW_API_KEY="865VuGn7RK8dUaByjfwa"
ENV FIREBASE_CREDENTIALS="{
  "type": "service_account",
  "project_id": "namepill-22uagc",
  "private_key_id": "dc5accb85279561f8caf14f6a4a2820ff89d998c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDTdhXM/YMNN0jY\nAIvkRAGdJQGwxKohQhkvqLHM8/tDfsjnLiUMW5zkIeyJV3DgbcX1egd/9wmTqHFH\nxnF1TF5jtSq7FEAMtttxxJykbtCrI8XLUVb/Clayi8adwDgnEYsH3DGkUYnlhlxz\nII5ARDb3YXicJxkjiNUUKkAm0ofOVTH3atO8VAi5oyiUHBHyPjqOa/aWEKXd18RP\nfmBYpEE68A3aqqPJuk66T0daRIv7pRv2yrq3vCzbP8wulw590SKCJfUlaPhAkSmM\nAjSig/y+j/fgPjxVt0fP3+PAF/gdtos5BbwRuVjfKpWGjIU4amTj8FNAss7deSWS\nB2F4iNyhAgMBAAECggEABWX9IY2OZ6c/4PqO17UGH+X9rYawR5MEgcZQI3TuNv1u\n5WK82bRiKINuko0mw7Z+tn0TAWD4C8bR3UbRT0Dj0x6hLptqRQ7TImvuIi8lbOyP\n5mhbOM2pq+NITs89Kb9rj8/W7TiTDT7bV+myovyw1Or+Q1mGzWzHII2hc5JF6vov\nP/Ryu1dYL9eEEzkg8pA3P23Sp5wEPQ/kUc+ZrgCK/zFZmtpGanvxc/LpN7nVoE0U\n07OhvjNAbmKptUpfznaOp2fbk2acCnh5UBd0zBwq3usq9agQbLsR20pb0oj97Sqw\nvHG9aAyTa71oEqkS/KIrMAbNe5qg5i1hPNuvg3XdQQKBgQDrOKYp1lxtXYZDZiGf\nmM4Z4ftXr25KtLoqFe32HNcDZttJgdqTCjkngSXaWON2E38dbtRCENXt/8cbg4Oc\nJ2vw64gIDP44dgcrTI8afiKw6sdBf66FwoikRFQZZXUpLich3PS0110v6DSCAhDz\n1z59xBRp8IFV7/516GYa+c9BQQKBgQDmJB8RmraAang1AmpxZuRpHus3eMVQPejp\n1KqTikkhxb2hTPB7R6NSg0+pkRrgay3jXeVo2wAG2CELS6goT3HSscKR8XPPQb7x\nnomgPFJrPkmTMot228lHwXffUEO1f1y0IJ78p53ZUpBpIDqmZqksc3w4qccjuKSy\nFXwrxIVjYQKBgFGI0Gg+KsmqGokwVMValU55e8M4RzXUEZfXBCZEdu9x7t87CMXh\nTFB6PuHB4A6k0XIlYaQI6+7Us3LBEpTFQXBAZGXOAy0VFIUYw53+TQ4gQ7Nbi+ZH\nuU+fc7td5M/CdMQTMCujX2Tky5apGrE7UikMF7tlJ5/fUcgTJ5mAMCxBAoGBALYA\nEuHlLDbZ/D5PrsYHzNKlNPcld0VB8JQbLtqHHdarfo+1POkBelOirLk4m7ymhh+s\n/eOybY78FQXNyyo1yZoKIgkwnZlmMQ77hXNGwRc2pxDVhB13KvKoOZhM7X73PeTl\nd1XvaJGZDcNVTYyS227f1XkqKuZA+14qR4yFWceBAoGBAL69sMA3+R7PUt1ArU99\nboZyI5p30JNSNEWKXMhGFtdDVQ7zur22+rdb2BMYSuoqiH8rwk2BHS/LnIyHaBqO\nEV3fS4VGYhwvD7lX3rFgzG9BdeYCEKBzLi5Bvf6VSwMDLAfZToMW+Q9YJiKSgaOV\nFJZrWW79/3o05acHGgCEfCKw\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@namepill-22uagc.iam.gserviceaccount.com",
  "client_id": "110831991993452891922",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40namepill-22uagc.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}"

EXPOSE 8080

CMD ["python", "app.py"]
