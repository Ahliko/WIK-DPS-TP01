FROM rust:1.84
LABEL authors="ahliko"
WORKDIR /var/www/app
COPY dummy.rs .
COPY Cargo.toml .
COPY Cargo.lock .
RUN sed -i 's#src/main.rs#dummy.rs#' Cargo.toml
ENV PING_LISTEN_PORT=3030
RUN cargo build --release
RUN sed -i 's#dummy.rs#src/main.rs#' Cargo.toml
COPY . .
RUN cargo build --release
RUN chown -R 1000:1000 /var/www/app
USER 1000
CMD ["./target/release/WIK-DPS-TP01"]