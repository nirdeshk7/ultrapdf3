# backend/main.py
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse
import shutil, os, uuid
from pypdf import PdfMerger

app = FastAPI(title="Online2PDF Clone (backend)")

UPLOAD_DIR = "/app/uploads"
MERGED_DIR = "/app/merged"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(MERGED_DIR, exist_ok=True)

def merge_pdfs(file_paths, output_path):
    merger = PdfMerger()
    for p in file_paths:
        merger.append(p)
    merger.write(output_path)
    merger.close()

@app.get("/")
def root():
    return {"status": "ok"}

@app.post("/merge")
async def merge_endpoint(files: list[UploadFile] = File(...)):
    saved = []
    try:
        for f in files:
            dest = os.path.join(UPLOAD_DIR, f.filename)
            with open(dest, "wb") as out:
                shutil.copyfileobj(f.file, out)
            saved.append(dest)

        out_name = f"merged_{uuid.uuid4().hex}.pdf"
        out_path = os.path.join(MERGED_DIR, out_name)
        merge_pdfs(saved, out_path)

        return FileResponse(out_path, filename=out_name)
    finally:
        # cleanup uploaded files (keep merged result for download)
        for p in saved:
            if os.path.exists(p):
                os.remove(p)
