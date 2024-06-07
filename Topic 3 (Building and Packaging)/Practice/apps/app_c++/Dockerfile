FROM debian:bullseye

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential=12.9 cmake=3.18.4-2+deb11u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN mkdir build \
    && cmake -S . -B build \
    && cmake --build build

ENTRYPOINT [ "build/main" ]
