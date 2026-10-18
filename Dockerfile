FROM python:3.12-alpine
RUN apk upgrade --no-cache

WORKDIR /app

RUN adduser -D -h /home/cloudforge -s /sbin/nologin cloudforge

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY run.py .

RUN chown -R cloudforge:cloudforge /app

USER cloudforge

EXPOSE 5000

CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:5000", "run:app"]
