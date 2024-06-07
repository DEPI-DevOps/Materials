# app_go

## Initialization

```bash
go mod init app
go get github.com/labstack/echo/v4
go get github.com/labstack/echo/v4/middleware
go run main.go # or `go build main.go && ./main`
```

## Development

```bash
go mod tidy
go run main.go
```

## Production

```bash
docker build -t app_go .
docker run --rm -it app_go
```
