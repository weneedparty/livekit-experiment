# Server

#### Usage

```bash
sudo apt install golang -y

#go get -d -u -t ./... && go mod tidy
go get

go run &
```

#### For developers

##### Test

```bash
go test tests/database_test.go #all test functions will run in a sequence way
```

##### Build

```bash
mkdir binary
cd binary
gox -output="TGbot_{{.OS}}_{{.Arch}}" -osarch="linux/amd64" -osarch="darwin/arm64" ../

#gox -output="LocalShow_{{.OS}}_{{.Arch}}" -osarch="linux/amd64" -osarch="linux/arm64" -osarch="windows/amd64" -osarch="windows/386" ../
```

##### Upload to server

```bash
rsync -avh --progress binary/server_linux_amd64 root@23.88.103.76:/root/livekit_config/livekit-test.ai-tools-online.xyz/call_service

#rsync -avh --progress SourceDir/* username@remote_host:TargetDir/
```

##### Run it on server

```bash
./call_service &
```
