package main

import (
  "fmt"
  "time"
  "runtime"
)

func hello() {
  fmt.Println("Go! Post.e")
}

func main() {
  go hello()
  time.Sleep(1 * time.Second)
  fmt.Println("Delay!")
  fmt.Printf("Go Version: %s\n", runtime.Version())
}

