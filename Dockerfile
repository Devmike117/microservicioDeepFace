
# Imagen base ligera compatible con DeepFace y OpenCV
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

# Copia los archivos del proyecto
COPY . /app

# Copia los pesos de DeepFace al contenedor
COPY .deepface/weights /root/.deepface/weights

# Instala dependencias desde requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expone el puerto que Railway redirige internamente
EXPOSE 8000

# Ejecuta Uvicorn con el puerto dinámico proporcionado por Railway
CMD ["uvicorn", "deepface_service:app", "--host", "0.0.0.0", "--port", "8000"]
