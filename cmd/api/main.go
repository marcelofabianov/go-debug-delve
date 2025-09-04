package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	if err := run(); err != nil {
		log.Printf("error: server shut down: %v", err)
		os.Exit(1)
	}
}

func run() error {
	port := os.Getenv("APP_API_PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", helloWorldHandler)

	addr := fmt.Sprintf(":%s", port)
	log.Printf("info: starting server on %s", addr)

	return http.ListenAndServe(addr, mux)
}

func helloWorldHandler(w http.ResponseWriter, r *http.Request) {
	message := "Hello, World from Docker Debug!"
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, message)
}
