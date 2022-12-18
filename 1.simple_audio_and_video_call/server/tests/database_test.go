package tests

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"gorm.io/gorm"

	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/database"
	"github.com/weneedparty/livekit-experiment/1.simple_audio_and_video_call/server/store"

	"github.com/yingshaoxo/gopython/terminal_tool"
)

var db *gorm.DB
var my_context context.Context
var cancel context.CancelFunc

var chat_id string = "11"

func TestMain(m *testing.M) {
	my_context, cancel = context.WithTimeout(context.Background(), 10000*time.Second)
	defer cancel()

	db = database.Init_database(store.Sqlite_database_test_file_path)
	fmt.Println("database initialized")
	defer func() {
	}()

	code := m.Run()
	fmt.Printf("the code of TestMain returns: %v", code)

	// disk_tool.Remove_a_file_or_folder("test.db")
	os.Exit(code)
}

func Test_if_database_exists(t *testing.T) {
	result := terminal_tool.Run_command("ls -l")

	// built_in_functions.Print(result)
	if !strings.Contains(result, "test.db") {
		t.Fatalf("There should have a file called 'test.db'")
	}
}
