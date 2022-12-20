package call_service

import (
	"context"
	"log"
	"net"
	"time"

	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/generated_grpc"
	"google.golang.org/grpc"

	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/livekit"
	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/store"
)

type GrpcCallServer struct {
	generated_grpc.UnimplementedCallServiceServer
	my_live_kit_controller livekit.MyLiveKitController
	call_info_dict         map[string]string
	token_dict             map[string]string
}

func (s *GrpcCallServer) clean_call_data_related_two_users(email1 string, email2 string) {
	delete(s.call_info_dict, email1)
	delete(s.call_info_dict, email2)

	delete(s.call_info_dict, email1)
	delete(s.call_info_dict, email2)

	delete(s.token_dict, email1)
	delete(s.token_dict, email2)
}

func (s *GrpcCallServer) SayHello(context_ context.Context, in *generated_grpc.HelloRequest) (*generated_grpc.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &generated_grpc.HelloReply{Message: "Hello " + in.GetName()}, nil
}

func (s *GrpcCallServer) IAmOnline(context_ context.Context, in *generated_grpc.OnlineRequest) (*generated_grpc.OnlineResponse, error) {
	default_response := &generated_grpc.OnlineResponse{
		Error:         "",
		JsonString:    "",
		CallComing:    false,
		RoomName:      "",
		CallInitiator: "",
		Token:         "",
	}

	call_initiator, ok := s.call_info_dict[in.Email]
	if ok {
		default_response.CallComing = true
		default_response.RoomName = call_initiator
		default_response.CallInitiator = call_initiator
		default_response.Token = s.my_live_kit_controller.Get_room_join_token(call_initiator, in.Email)
		s.token_dict[in.Email] = default_response.Token

		time.Sleep(500000000)

		s.clean_call_data_related_two_users(in.Email, call_initiator)
	}

	return default_response, nil
}

func (s *GrpcCallServer) MakeACall(context_ context.Context, in *generated_grpc.CallRequest) (*generated_grpc.CallResponse, error) {
	default_response := &generated_grpc.CallResponse{
		Error:      "",
		JsonString: "",
		RoomName:   "",
		Token:      "",
	}

	default_response.RoomName = in.Email
	s.call_info_dict[in.TargetEmail] = in.Email

	default_response.Token = s.my_live_kit_controller.Get_room_join_token(in.Email, in.Email)
	s.token_dict[in.Email] = default_response.Token

	s.token_dict[in.TargetEmail] = "none"
	for true {
		target_token, ok := s.token_dict[in.TargetEmail]
		if ok {
			if target_token != "none" && target_token != "" {
				//the target have accepted the call, and gnerated a token for joing the room
				break
			}

			if target_token == "" {
				//refuse to answer
				default_response.RoomName = ""
				default_response.Token = ""
				return default_response, nil
			}
		}

		if context_.Err() != nil {
			default_response.RoomName = ""
			default_response.Token = ""

			s.clean_call_data_related_two_users(in.Email, in.TargetEmail)

			return default_response, nil
		}

		time.Sleep(100000000)
	}

	return default_response, nil
}

//address example: 127.0.0.1:40058 ; 40059 is used for web grpc
func (_ GrpcCallServer) Start(grpc_call_server *GrpcCallServer, address string, context_ context.Context) {
	lis, err := net.Listen("tcp", address)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()

	my_livekit_controller := livekit.MyLiveKitController{
		Content:       context_,
		Host:          store.Livekit_host_https_address,
		Api_key:       store.Livekit_api_key,
		Api_secret:    store.Livekit_api_secret,
		Identity_name: "root",
	}
	my_livekit_controller.Init(&my_livekit_controller)

	grpc_call_server.my_live_kit_controller = my_livekit_controller
	grpc_call_server.call_info_dict = make(map[string]string)
	grpc_call_server.token_dict = make(map[string]string)

	generated_grpc.RegisterCallServiceServer(s, grpc_call_server)
	log.Printf("server listening at %v", lis.Addr())

	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
