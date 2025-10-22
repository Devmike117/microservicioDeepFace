FROM python:3.10-bookworm

# Instala solo lo esencial
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Usa pip sin caché
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

ENV PORT=8000
EXPOSE $PORT

CMD uvicorn deepface_service:app --host 0.0.0.0 --port=${PORT}
