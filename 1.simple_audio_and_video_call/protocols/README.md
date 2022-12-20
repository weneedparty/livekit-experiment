# GRPC Protocols

## generate the code (just example, don't run it directly!)

### Golang
```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

mkdir ./generated_grpc

protoc --go_out=generated_grpc --go_opt=paths=source_relative --go-grpc_out=generated_grpc --go-grpc_opt=paths=source_relative --proto_path ../protocols call_service.proto
```

### Flutter
```bash
mkdir -p lib/generated_grpc

protoc --dart_out=grpc:lib/generated_grpc --proto_path ../protocols call_service.proto
```