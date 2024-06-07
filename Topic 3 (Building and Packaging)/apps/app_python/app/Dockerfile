FROM python:alpine

COPY . /app

WORKDIR /app

RUN apk add --update --no-cache libqrencode~=4 \
    && pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python3", "app.py"]
