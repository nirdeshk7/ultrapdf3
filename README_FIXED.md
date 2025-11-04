Fixed repo for Online2PDF (minimal MVP)

What I changed:
- Ensured backend/main.py exists with FastAPI app (POST /merge endpoint).
- Ensured backend/requirements.txt exists.
- Added Dockerfile in repo root that installs backend requirements and runs 'uvicorn backend.main:app'.

How to test locally (requires Docker):
1) Build image:
   docker build -t online2pdf:fixed .

2) Run container:
   docker run --rm -p 8000:8000 online2pdf:fixed

3) Visit:
   http://127.0.0.1:8000/docs

If you are deploying to Render.com as a Docker deploy, push the image or connect the repo and let Render build.
If you are using Render's native (non-Docker) deploy, set the Start Command to:
   uvicorn backend.main:app --host 0.0.0.0 --port $PORT
