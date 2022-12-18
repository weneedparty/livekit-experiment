package call_service

import (
	"context"
	"log"
	"net"

	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/generated_grpc"
	"google.golang.org/grpc"
)

type GrpcCallServer struct {
	generated_grpc.UnimplementedCallServiceServer
	// a_varible string
}

func (s *GrpcCallServer) SayHello(context_ context.Context, in *generated_grpc.HelloRequest) (*generated_grpc.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &generated_grpc.HelloReply{Message: "Hello " + in.GetName()}, nil
}

//address example: 127.0.0.1:40058 ; 40059 is used for web grpc
func (_ GrpcCallServer) Start(grpc_call_server *GrpcCallServer, address string) {
	lis, err := net.Listen("tcp", address)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	generated_grpc.RegisterCallServiceServer(s, grpc_call_server)
	log.Printf("server listening at %v", lis.Addr())

	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
