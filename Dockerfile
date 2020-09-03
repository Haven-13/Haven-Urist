FROM tgstation/byond:513.1528

ENV PATH=/root/cargo/bin:/root/rustup/bin:$PATH\
	CARGO_HOME=/root/cargo\
	RUSTUP_HOME=/root/rustup

RUN apt-get update && apt-get install -y curl git gcc-multilib;\
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init; \
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path;\
	rm rustup-init;\
	rustup default stable;\
	rustup target add i686-unknown-linux-gnu

RUN git clone https://github.com/Lohikar/byhttp.git || true
WORKDIR /byhttp
RUN mkdir to_copy;\
	cargo build --release --target i686-unknown-linux-gnu;\
	mv -t to_copy target/i686-unknown-linux-gnu/release/libbyhttp.so || true

FROM tgstation/byond:513.1528

ARG BUILD_ARGS
ARG RUN_USER=root

RUN apt-get update && apt-get install -y gosu

ENV RUN_AS=${RUN_USER}
ENV BUILD_TARGET=baystation12
ENV BUILD_DIR=/docker-deployed-${BUILD_TARGET}

COPY . ${BUILD_DIR}
COPY --from=0 /byhttp/to_copy ${BUILD_DIR}/lib

WORKDIR ${BUILD_DIR}
RUN ./scripts/dm.sh ${BUILD_ARGS} ${BUILD_TARGET}.dme

EXPOSE 8000
VOLUME ${BUILD_DIR}/data
VOLUME ${BUILD_DIR}/config

ENTRYPOINT ["./scripts/docker-entrypoint.sh"]