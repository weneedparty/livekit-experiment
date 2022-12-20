#!/bin/sh

#sudo apt install golang -y
#go get ./... && go mod tidy

name="server"

go install github.com/mitchellh/gox@latest
export PATH=~/go/bin:$PATH

mkdir binary
cd binary
gox -output="${name}_{{.OS}}_{{.Arch}}" -osarch="linux/amd64" -osarch="darwin/arm64" ../

executable_target_path="$(pwd)/${name}_linux_amd64"
chmod 777 $executable_target_path

remind="$executable_target_path"
echo '\n'
echo 'Run the following command:\n'
echo $remind

rsync -avh --progress ${executable_target_path} root@23.88.103.76:/root/livekit_config/livekit-test.ai-tools-online.xyz/call_service