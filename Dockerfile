FROM alpine:3.5
RUN apk --update add git build-base openssl-dev linux-headers lua5.2 lua5.2-dev libfetch-dev llvm-dev clang
# Build afl
COPY ./afl-2.41b /tmp/afl-2.41b
# Does not compile with clang (so no afl-clang-fast)
RUN cd /tmp/afl-2.41b && make && make install

# Compile apk-tools
COPY ./apk-tools /apk-tools
ENV CC="afl-gcc"
RUN cd apk-tools && make -n && make install

# Sanity
RUN  afl-showmap -o /dev/null apk version
