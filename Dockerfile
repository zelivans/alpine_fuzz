FROM alpine:3.5
RUN apk --update add git build-base openssl-dev linux-headers lua5.2 lua5.2-dev libfetch-dev llvm-dev clang
# Build afl
COPY ./afl-2.41b /tmp/afl-2.41b
RUN cd /tmp/afl-2.41b && make && make -C llvm_mode && make install

# Compile apk-tools
COPY ./apk-tools /apk-tools
ENV CC="afl-clang-fast"
RUN cd apk-tools && make && make install
