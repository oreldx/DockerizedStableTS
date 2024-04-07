import os

import stable_whisper
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename


app = Flask(__name__)

model = stable_whisper.load_faster_whisper(
    model_size_or_path="large-v2",
    download_root=os.path.abspath("models"),
)

ALLOWED_EXTENSIONS = {"wav", "mp3", "ogg", "m4a"}
app.config["UPLOAD_FOLDER"] = os.getenv("UPLOAD_FOLDER")
app.config["MAX_CONTENT_LENGTH"] = os.getenv("MAX_CONTENT_LENGTH")


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/")
def index():
    return "Hello, World!"


@app.route("/transcribe", methods=["POST"])
def transcribe():
    if "file" not in request.files:
        return jsonify(error="No file part"), 400
    file = request.files["file"]

    if file.filename == "":
        return jsonify(error="No selected file"), 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
        file.save(file_path)

        result = model.transcribe_stable(file_path)

        os.remove(file_path)
        return jsonify(result.to_srt_vtt())

    return jsonify(error="Invalid file type"), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0")
