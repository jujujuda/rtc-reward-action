FROM python:3.11-slim
WORKDIR /app
COPY entrypoint.sh /entrypoint.sh
COPY src/ /app/src/
RUN pip install requests
ENTRYPOINT ["/entrypoint.sh"]
