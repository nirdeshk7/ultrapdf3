# Dockerfile — rust-enabled build for pydantic-core
FROM python:3.11-slim

WORKDIR /app

# Install apt deps needed to build some python packages + curl for rustup
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential curl ca-certificates gcc libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Install rustup (non-interactive) and set PATH for this layer
ENV RUSTUP_HOME=/rustup \
    CARGO_HOME=/cargo \
    PATH=/cargo/bin:/root/.cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    rustup default stable

# Copy requirements and install python deps (now rust available)
COPY backend/requirements.txt ./backend/requirements.txt
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r backend/requirements.txt

# Copy rest of project
COPY . .

# create runtime dirs
RUN mkdir -p /app/uploads /app/merged && chmod -R 777 /app/uploads /app/merged

EXPOSE 8000
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
