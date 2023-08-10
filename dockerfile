# Stage 1: Build the binary
FROM debian:bullseye-slim AS builder

# Install required packages
RUN apt-get update && apt-get install -y gcc make libc6-dev

# Copy the project files into the container
WORKDIR /src
COPY . .

# Statically compile the C server binary
RUN gcc -static -o server server.c

# Stage 2: Create the alpine container
FROM alpine:latest

# Copy the statically compiled server binary into the alpine container
COPY --from=builder /src/server /server

# Expose the server port
EXPOSE 8080

# Run the server binary
CMD ["/server"]
