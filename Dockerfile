FROM python:3.12-slim AS builder 

WORKDIR  /app 

COPY requirements.txt . 

RUN pip install --user --no-cache-dir -r requirements.txt 

FROM python:3.12-slim 

WORKDIR  /app 

COPY --from=builder /root/.local /root/.local 

COPY . .

RUN apt-get update && apt-get install -y wait-for-it \
  && rm -rf usr/lib/apt/lists/* 

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
 CMD python manage.py check || exit 1 

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]