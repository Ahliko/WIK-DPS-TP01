FROM rust:1.84
LABEL authors="ahliko"
WORKDIR /var/www/app
COPY dummy.rs .
COPY Cargo.toml .
COPY Cargo.lock .
RUN sed -i 's#src/main.rs#dummy.rs#' Cargo.toml
ENV PING_LISTEN_PORT=3030
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release --target=x86_64-unknown-linux-musl
RUN sed -i 's#dummy.rs#src/main.rs#' Cargo.toml
COPY . .
RUN cargo build --release --target=x86_64-unknown-linux-musl
RUN chown -R 1000:1000 /var/www/app
USER 1000

FROM alpine:latest
LABEL authors="ahliko"
WORKDIR /var/www/app/
COPY --from=0 /var/www/app/target/x86_64-unknown-linux-musl/release/WIK-DPS-TP01 ./
USER 1000
CMD ["./WIK-DPS-TP01"]