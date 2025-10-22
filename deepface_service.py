from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from deepface import DeepFace
import os

app = FastAPI(title="DeepFace Embedding Service")

# CORS: en producción, reemplaza "*" por tus dominios específicos
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"status": "Servicio activo", "endpoint": "/generate_embedding"}

@app.post("/generate_embedding/")
async def generate_embedding(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        raise HTTPException(status_code=400, detail="Formato de archivo no soportado")

    file_location = f"/tmp/temp_{file.filename}"
    try:
        with open(file_location, "wb") as f:
            f.write(await file.read())

        result = DeepFace.represent(img_path=file_location, model_name='Facenet', enforce_detection=True)

        if not result or len(result) == 0:
            raise HTTPException(status_code=400, detail="No se detectó ninguna cara en la imagen")

        embedding_vector = result[0]["embedding"]
        embedding_list = embedding_vector if isinstance(embedding_vector, list) else embedding_vector.tolist()

        print(f"Embeddings generados para {file.filename}:\n{embedding_list}\n")

        return {"embedding": embedding_list, "model": "Facenet"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generando embedding: {str(e)}")

    finally:
        if os.path.exists(file_location):
            os.remove(file_location)






