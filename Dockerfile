# Dockerfile (Includes all previous fixes: Rust/Cargo, and new fix for path/case)
FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libreoffice tesseract-ocr ghostscript poppler-utils curl \
    build-essential rustc cargo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# FIX 1: Copy requirements file separately using the correct name (assuming you fixed the name to lowercase)
# Ye ensure karta hai ki file mil jaaye aur caching sahi ho
COPY backend/requirements.txt /app/backend/

# Python deps
WORKDIR /app/backend 
RUN python -m venv /opt/venv && . /opt/venv/bin/activate && \
    pip install --upgrade pip && pip install -r requirements.txt
    
# Copy the rest of the application code
COPY . /app/
WORKDIR /app

ENV PATH="/opt/venv/bin:$PATH"

# Render provides $PORT
CMD ["bash", "-lc", "uvicorn backend.app:app --host 0.0.0.0 --port ${PORT:-8000}"]
