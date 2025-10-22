# Imagen base ligera compatible con TensorFlow y DeepFace
FROM python:3.10-slim-bookworm

# Evita prompts durante instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instala librerías necesarias para OpenCV y DeepFace
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define el directorio de trabajo
WORKDIR /app

# Copia el proyecto
COPY . /app

# Instala dependencias desde requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Define puerto por defecto
ENV PORT=8000
EXPOSE 8000

# Ejecutar con shell para que ${PORT} se expanda correctamente
CMD sh -c "uvicorn deepface_service:app --host 0.0.0.0 --port ${PORT:-8000}"
