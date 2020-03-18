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

# Gcloud capable image
FROM google/cloud-sdk

COPY --from=builder /app/server /server
COPY --from=builder /app/start-gcloud.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh", "/server"]
