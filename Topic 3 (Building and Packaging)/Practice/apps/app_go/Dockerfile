FROM golang:alpine

WORKDIR /app

ENV CGO_ENABLED=false

COPY . .

RUN go mod tidy

EXPOSE 3000

CMD ["go", "run", "main.go"]
