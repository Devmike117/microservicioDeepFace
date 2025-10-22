FROM python:3.10-slim

# Instala dependencias del sistema necesarias para OpenCV
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Crea directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . /app

# Instala dependencias de Python
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expone el puerto dinámico
ENV PORT=8000
EXPOSE $PORT

# Comando de inicio
CMD ["uvicorn", "deepface_service:app", "--host", "0.0.0.0", "--port", "8000"]
