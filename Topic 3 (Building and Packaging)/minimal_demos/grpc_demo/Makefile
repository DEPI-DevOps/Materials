all:
	python3 -m grpc_tools.protoc --proto_path=. --python_out=. --grpc_python_out=. greeter.proto

clean:
	rm -rf __pycache__/ venv/ db.sqlite greeter*.py