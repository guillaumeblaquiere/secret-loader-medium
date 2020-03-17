FROM golang:1.13 as builder

# Copy local code to the container image.
WORKDIR /app/
COPY go.mod .
ENV GO111MODULE=on
RUN go mod download

COPY . .

# Perform test for building a clean package
RUN go test -v ./...
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

# Minimal image
FROM alpine

COPY --from=builder /app/server /server

# Add the startup script and make it runable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Add the secret-loader tools and make it runable
RUN wget https://storage.googleapis.com/secret-loader/master/linux64/secret-loader
RUN chmod +x /secret-loader

CMD ["/start.sh", "/server"]
