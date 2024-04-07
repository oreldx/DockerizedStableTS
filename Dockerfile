FROM python:3.10-slim

# TODO: install CUDnn
# RUN apt-get update && apt-get install -y && apt-get -y install cudnn9-cuda-12

ENV UPLOAD_FOLDER=/raw_uploads
ENV MAX_CONTENT_LENGTH=16777216

WORKDIR /usr/src/app
RUN mkdir -p ${UPLOAD_FOLDER}

COPY . .

RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

EXPOSE 5000

VOLUME ["/usr/src/app/models"]

CMD ["python", "./app.py"]