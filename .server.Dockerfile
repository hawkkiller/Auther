# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY server server
COPY shared shared

RUN cd server &&  \
    dart pub get &&  \
    dart run build_runner build --delete-conflicting-outputs && \
    dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM debian:buster-slim as final

# Here we are installing the SQLite3 lib
ENV SECRET_KEY=secret

COPY --from=build /runtime/ /
COPY --from=build /app/server/bin/server /app/bin/

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends libssl-dev sqlite3 libsqlite3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Start server.
EXPOSE 8080/tcp
CMD ["/app/bin/server"]
