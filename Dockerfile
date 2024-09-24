# Stage 1: Build the Go application
FROM golang:1.23.1 AS builder

# Set the current working directory inside the container
WORKDIR /app

# Copy the go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o hello-world .

# Stage 2: Create a minimal image
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/hello-world .

# Command to run the executable
CMD ["./hello-world"]
