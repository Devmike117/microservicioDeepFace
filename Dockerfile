FROM python:3.10-bookworm

# Instala solo lo esencial para DeepFace/OpenCV
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define directorio de trabajo
WORKDIR /app

# Copia el contenido del proyecto
COPY . /app

# Instala dependencias sin caché
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expone el puerto (Railway lo asigna dinámicamente)
ENV PORT=8000
EXPOSE 8000

# Comando de inicio con puerto fijo (Railway lo redirige internamente)
CMD ["uvicorn", "deepface_service:app", "--host", "0.0.0.0", "--port", "8000"]
