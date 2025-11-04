# Dockerfile (Simplified COPY process)
FROM python:3.11-slim

# System dependencies (Rust/Cargo included)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libreoffice tesseract-ocr ghostscript poppler-utils curl \
    build-essential rustc cargo \
    && rm -rf /var/lib/apt/lists/*

# Set up the application directory
WORKDIR /app

# Step 1: Copy ONLY the backend folder for dependency installation
# Isse Docker ko sirf zaroori files mil jayengi.
# FIX: Sirf backend folder ko copy karein
COPY backend/ /app/backend/ 

# Python deps
WORKDIR /app/backend 
RUN python -m venv /opt/venv && . /opt/venv/bin/activate && \
    pip install --upgrade pip && pip install -r requirements.txt
    
# Step 2: Copy the rest of the application code
WORKDIR /app
COPY . /app/
# NOTE: Ab /app/backend/ bhi /app/backend/ se overwrite ho jayega, but dependencies installed hain

ENV PATH="/opt/venv/bin:$PATH"

# Render provides $PORT
# CMD mein path bhi confirm kar lein ki FastAPI app kahaan hai (backend/app.py)
CMD ["bash", "-lc", "uvicorn backend.app:app --host 0.0.0.0 --port ${PORT:-8000}"]
