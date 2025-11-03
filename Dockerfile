FROM python:3.13-slim AS builder

RUN mkdir /app
RUN mkdir /db
RUN mkdir /mediaroot
WORKDIR /app


ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1 


COPY app/ /app

RUN pip install --upgrade pip  && \
    pip install --no-cache-dir -r requirements.txt

FROM python:3.13-slim
RUN useradd -m -r appuser && \
   mkdir /app && \
   chown -R appuser /app

COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

WORKDIR /app
COPY --chown=appuser:appuser app/ /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBUG=0
ENV ALLOWED_HOSTS=*



USER appuser

EXPOSE 8000

ENTRYPOINT ["gunicorn", "seemyping.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "60", "--chdir", "/app"]