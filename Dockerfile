FROM golang:1.23 as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -o main .

# Final stage - Distroless image

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]