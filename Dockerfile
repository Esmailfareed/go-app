FROM golang:1.22 AS build
WORKDIR /app
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

FROM gcr.io/distroless/static:nonroot
WORKDIR /app
COPY --from=build --chown=nonroot:nonroot /app/main /app/main
COPY --from=build --chown=nonroot:nonroot /app/static /app/static
EXPOSE 8080
USER nonroot:nonroot
CMD ["/app/main"]