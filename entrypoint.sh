#!/bin/sh
exec uvicorn deepface_service:app --host 0.0.0.0 --port=${PORT:-8000}
