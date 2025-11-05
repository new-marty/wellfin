# Build stage
FROM swift:5.9-jammy as build
WORKDIR /build

# Cache dependencies
COPY apps/api/Package.* ./
COPY packages/SharedKit ./packages/SharedKit
RUN swift package resolve

# Build
COPY apps/api ./
RUN swift build -c release --product Run

# Run stage
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y libatomic1 libbsd0 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /build/.build/release/Run /app/Run
ENV PORT=8080
EXPOSE 8080
CMD ["./Run"]





