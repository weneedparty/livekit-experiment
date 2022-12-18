package livekit

import (
	"context"
	"errors"
	"log"
	"time"

	"github.com/livekit/protocol/auth"
	livekit_protocol "github.com/livekit/protocol/livekit"
	livekit_sdk "github.com/livekit/server-sdk-go"
)

type MyLiveKitController struct {
	Content         context.Context
	Host            string
	Api_key         string
	Api_secret      string
	Identity_name   string
	Room_controller *livekit_sdk.RoomServiceClient
}

func (_ MyLiveKitController) Init(my_livekit_controller *MyLiveKitController) {
	if len(my_livekit_controller.Identity_name) == 0 {
		my_livekit_controller.Identity_name = "root"
	}

	my_livekit_controller.Room_controller = livekit_sdk.NewRoomServiceClient(my_livekit_controller.Host, my_livekit_controller.Api_key, my_livekit_controller.Api_secret)
}

func (my_livekit_controller MyLiveKitController) make_sure_init() {
	not_initiated := false

	if my_livekit_controller.Room_controller == nil {
		not_initiated = true
	}

	if not_initiated {
		panic(errors.New("You should call my_livekit_controller.Init(my_livekit_controller) before you do anything else!"))
	}
}

func (my_livekit_controller MyLiveKitController) Get_room_join_token(room_name string, identity_name string) string {
	my_livekit_controller.make_sure_init()

	at := auth.NewAccessToken(my_livekit_controller.Api_key, my_livekit_controller.Api_secret)
	grant := &auth.VideoGrant{
		RoomJoin: true,
		Room:     room_name,
	}
	at.AddGrant(grant).
		SetIdentity(identity_name).
		SetValidFor(time.Hour)

	token, err := at.ToJWT()
	if err != nil {
		token = ""
		log.Fatal(err)
	}

	return token
}

func (my_livekit_controller MyLiveKitController) Create_a_room(room_name string, timeout_in_seconds uint32) *livekit_protocol.Room {
	my_livekit_controller.make_sure_init()

	room, err := my_livekit_controller.Room_controller.CreateRoom(my_livekit_controller.Content, &livekit_protocol.CreateRoomRequest{
		Name:         room_name,
		EmptyTimeout: timeout_in_seconds,
	})
	if err != nil {
		room = nil
		log.Fatal(err)
	}

	return room
}
