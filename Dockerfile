FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY cloudbot.py ./
RUN mkdir -p /app/upload_bots /app/inf \
    && chmod 700 /app/upload_bots /app/inf

EXPOSE 8080
CMD ["python", "cloudbot.py"]
