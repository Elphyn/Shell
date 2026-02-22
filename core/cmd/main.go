package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/coreos/go-systemd/v22/dbus"
)

func isDirExists(path string) bool {
	info, err := os.Stat(path)
	if os.IsNotExist(err) {
		return false
	}

	return err == nil && info.IsDir()
}

func setupFileLogger() (*os.File, error) {
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	home, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("Failed to get home directory, %w", err)
	}

	logDir := filepath.Join(home, "logs")

	if !isDirExists(logDir) {
		if err := os.Mkdir(logDir, 0755); err != nil {
			return nil, fmt.Errorf("Failed to create directory: %w", err)
		}
	}

	file, err := os.OpenFile(filepath.Join(logDir, "app.log"), os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		return nil, fmt.Errorf("Failed to open log file: %w", err)
	}

	log.SetOutput(file)

	return file, nil
}

type ServiceManager struct {
	conn *dbus.Conn

	unitName string
}

func CreateServiceManager(conn *dbus.Conn, unitName string) (*ServiceManager, error) {
	manager := &ServiceManager{
		conn:     conn,
		unitName: unitName,
	}

	err := manager.start()
	if err != nil {
		return nil, err
	}

	return manager, nil
}

func (m *ServiceManager) start() error {
	resultCh := make(chan string)
	_, err := m.conn.StartUnitContext(context.Background(), m.unitName, "replace", resultCh)
	if err != nil {
		return err
	}

	select {
	case result := <-resultCh:
		switch result {
		case "done":
			log.Printf("Service for %v has started", m.unitName)
		default:
			log.Printf("Unexpected result: %s", result)
			return err
		}
	}

	return nil
}

func main() {
	// logFile, err := setupFileLogger()
	// if err != nil {
	// 	log.Fatal(err)
	// 	os.Exit(1)
	// }
	// defer logFile.Close()

	conn, err := dbus.NewWithContext(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	zapretName := "zapret.service"

	_, err = CreateServiceManager(conn, zapretName)
	if err != nil {
		log.Printf("Zapret serviceManager failed, %v", err)
	}
}
