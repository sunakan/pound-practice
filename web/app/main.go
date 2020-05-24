package main

import (
  "fmt"
  "net/http"
  "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "Hello, Golang by " + os.Getenv("DOCKER_HOSTNAME"))
}

func main() {
  http.HandleFunc("/", handler)
  http.ListenAndServe(":" + os.Getenv("PORT"), nil)
}
