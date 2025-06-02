#!/bin/bash

VERSION=${1:-"dev"}

GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc go build -ldflags "-X main.version=$VERSION" -o schema-windows-amd64.exe
GOOS=linux GOARCH=amd64 CGO_ENABLED=1 CC=gcc go build -ldflags "-X main.version=$VERSION" -o schema-linux-amd64
