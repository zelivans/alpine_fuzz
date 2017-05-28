FROM alpine:3.5
RUN apk --update add git build-base openssl-dev linux-headers lua5.2 lua5.2-dev libfetch-dev
# Build afl
COPY ./afl-2.41b /tmp/afl-2.41b
RUN cd /tmp/afl-2.41b && make && make install

# Compile apk-tools
# Do not forget - edit the Make.rules file to comment out the 3 CROSS_COMPILE lines
COPY ./apk-tools /apk-tools

# Does not compile with clang (so no afl-clang-fast)
ENV CC="afl-gcc"
RUN cd apk-tools && make -n && make install

# Sanity
RUN afl-showmap -o /dev/null apk version

# --- Setup fuzzing --- 
VOLUME /corpus
VOLUME /outdir

# Make sure afl-tmin is ran on corpus. To do that - run with --entrypoint "/bin/sh" and run
# for i in /corpus/*; do afl-tmin -i $i -o /corpus/$i.min -- /apk-tools/src/apk fz @@; done;
# Todo 2: multiple instances
ENTRYPOINT ["afl-fuzz", "-i", "/corpus/actual", "-o" ,"/outdir/", "/apk-tools/src/apk fz @@"]
