FROM nvidia/cuda:11.4.3-cudnn8-runtime-ubuntu20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install --no-install-recommends -y python3.11 python3-distutils python3-pip && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update 

ENV UPLOAD_FOLDER=/raw_uploads
ENV MODEL=large-v2
ENV MAX_CONTENT_LENGTH=16777216

WORKDIR /usr/src/app
RUN mkdir -p ${UPLOAD_FOLDER}

COPY . .

RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

EXPOSE 5000

VOLUME ["/usr/src/app/models"]

CMD ["python3.11", "./app.py"]