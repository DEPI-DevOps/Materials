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

## Jenkins server initialization

```bash
sudo apt install docker.io docker-buildx
sudo groupadd docker
sudo usermod -aG docker jenkins
newgrp docker
sudo systemctl restart jenkins
```
