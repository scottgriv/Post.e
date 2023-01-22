package main

import (
    "database/sql"
    _ "github.com/Go-SQL-Driver/MySQL"
    "log"
)

const (
    DB_HOST = "tcp(127.0.0.1:3306)"
    DB_NAME = "post.e"
    DB_USER = /*"root"*/ "root"
    DB_PASS = /*""*/ ""
)

func main() {
    dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()
    var str string
    q := "SELECT User_ID, User_Name FROM USER WHERE User_ID = ?"
    err = db.QueryRow(q, 1).Scan(&str)
    if err != nil {
        log.Fatal(err)
    }
    log.Println(str)
}