package main

// try to convert database module to a 'class' style module if you can

import (
	"context"
	"io"
	"log"

	// "net/http"
	"os"

	// "gorm.io/gorm"
	// "github.com/gin-gonic/gin"

	"github.com/yingshaoxo/gopython/disk_tool"
	// "github.com/yingshaoxo/gopython/string_tool"
	// "github.com/yingshaoxo/gopython/time_tool"

	// "github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/database"
	// "github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/tools"
	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/call_service"
)

var context_ context.Context
var err error

// var db *gorm.DB

func setup_logger(log_file_path string) {
	// delete old log
	if disk_tool.Exists(log_file_path) {
		disk_tool.Remove_a_file_or_folder(log_file_path)
	}
	// set log file
	f, err := os.OpenFile(log_file_path, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	// defer f.Close()
	wrt := io.MultiWriter(os.Stdout, f)
	log.SetOutput(wrt)
}

func main() {
	// set logger
	current_path := disk_tool.Get_current_working_directory()
	if len(current_path) != 0 {
		log_file_path := disk_tool.Path_join(current_path, "log.txt")
		//built_in_functions.Print(log_file_path)
		setup_logger(log_file_path)
	}

	// set database
	// db = database.Init_database(store.Sqlite_database_file_path)

	// your code here

	// go telegram_bot_loop()
	// my_operation_loop()

	// my_livekit_controller := livekit.MyLiveKitController{
	// 	Content:       context_,
	// 	Host:          store.Livekit_host_https_address,
	// 	Api_key:       store.Livekit_api_key,
	// 	Api_secret:    store.Livekit_api_secret,
	// 	Identity_name: "root",
	// }
	// my_livekit_controller.Init(&my_livekit_controller)

	// the_first_room_name := "number1"
	// room_time_out_in_seconds := 60 * 60 * 12 * 30 * 12
	// common_room := my_livekit_controller.Create_a_room(the_first_room_name, uint32(room_time_out_in_seconds))

	// token1 := my_livekit_controller.Get_room_join_token(common_room.Name, "yingshaoxo")
	// token2 := my_livekit_controller.Get_room_join_token(common_room.Name, "others")

	// fmt.Println("\n")
	// fmt.Printf(
	// 	"https://example.livekit.io/#/room?url=%v&token=%v&videoEnabled=1&audioEnabled=1&simulcast=1&dynacast=1&adaptiveStream=1&videoDeviceId=1\n",
	// 	store.Livekit_host_wss_address,
	// 	token1,
	// )
	// fmt.Println()
	// fmt.Printf(
	// 	"https://example.livekit.io/#/room?url=%v&token=%v&videoEnabled=1&audioEnabled=1&simulcast=1&dynacast=1&adaptiveStream=1&videoDeviceId=2\n",
	// 	store.Livekit_host_wss_address,
	// 	token2,
	// )

	context_ = context.Background()
	call_service := call_service.GrpcCallServer{}
	call_service.Start(&call_service, "127.0.0.1:40058", context_)

	// r := gin.Default()
	// r.GET("/ping", func(c *gin.Context) {
	// 	c.JSON(http.StatusOK, gin.H{
	// 		"message": "pong",
	// 	})
	// })
	// r.Run("0.0.0.0:12345") // listen and serve on 0.0.0.0:12345
}
