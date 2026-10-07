FROM golang:1.26.8-alpine3.24 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY cmd ./cmd
RUN CGO_ENABLED=0 go build -tags=nomsgpack -trimpath -ldflags="-s -w" -o /out/dify4go ./cmd/dify4go

FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=build --chown=nonroot:nonroot /out/dify4go /app/dify4go
EXPOSE 8080
ENTRYPOINT ["/app/dify4go"]
