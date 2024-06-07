FROM python:3-alpine

WORKDIR /app

COPY . .

RUN pip install grpcio grpcio-tools && python3 -m grpc_tools.protoc --proto_path=. --python_out=. --grpc_python_out=. schema.proto

ENTRYPOINT [ "python3" ]
