FROM golang:alpine AS build
RUN apk add --no-cache zig
WORKDIR /workspace
COPY . /workspace/
RUN CC="zig cc -target x86_64-windows-gnu" CXX="zig c++ -target x86_64-windows-gnu" CGO_ENABLED=1 GOOS=windows GOARCH=amd64 go build -ldflags='-s -w -extldflags "-static"' -o schema-windows-amd64.exe
RUN CC="zig cc -target x86_64-linux-musl" CXX="zig c++ -target x86_64-linux-musl" CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags='-s -w -extldflags "-static"' -o schema-linux-amd64

FROM scratch
COPY --from=build ./workspace/schema-windows-amd64.exe /usr/local/bin/schema-windows-amd64.exe
COPY --from=build ./workspace/schema-linux-amd64 /usr/local/bin/schema-linux-amd64

ENTRYPOINT ["/usr/local/bin/schema-windows-amd64.exe"]
