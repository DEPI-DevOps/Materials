all:
	python3 -m grpc_tools.protoc --proto_path=. --python_out=. --grpc_python_out=. schema.proto

clean:
	rm -rf __pycache__/ venv/ db.sqlite schema*.py
