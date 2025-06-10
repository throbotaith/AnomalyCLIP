FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

WORKDIR /workspace/AnomalyCLIP

COPY . /workspace/AnomalyCLIP

RUN pip install --no-cache-dir -r requirements.txt

CMD ["bash"]
