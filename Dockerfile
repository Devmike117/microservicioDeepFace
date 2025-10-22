FROM python:3.10-bookworm

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip && pip install -r requirements.txt

ENV PORT=8000
EXPOSE $PORT

CMD ["sh", "-c", "uvicorn deepface_service:app --host 0.0.0.0 --port $PORT"]
