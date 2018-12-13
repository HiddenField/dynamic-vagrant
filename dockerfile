FROM ubuntu:bionic as build-env
WORKDIR /dynamic
RUN apt-get -qq update
RUN apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libcrypto++-dev libevent-dev libzmq3-dev software-properties-common git
RUN apt-add-repository -y ppa:bitcoin/bitcoin
RUN apt-get update -y 
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
COPY . ./build/
WORKDIR /dynamic/build/apps/dynamic-private
RUN ./autogen.sh 
RUN ./configure --without-gui --disable-tests --disable-bench 
RUN make
FROM ubuntu:bionic
WORKDIR /dynamic
COPY --from=build-env /dynamic/build/apps/dynamic-private/src/dynamicd ./dist/
COPY --from=build-env /dynamic/build/apps/dynamic-private/src/dynamic-cli ./dist/
COPY --from=build-env /dynamic/build/apps/dynamic-private/src/dynamic-tx ./dist/
RUN apt-get update  \
    && apt-get install -y  \
        libzmq5 \
        libboost-system1.65.1 \
        libboost-filesystem1.65.1 \
        libboost-thread1.65.1 \
        libboost-chrono1.65.1 \
        libboost-program-options1.65.1 \
        libssl1.1 \
        libcrypto++6 \
        libevent-2.1-6 \
        libevent-pthreads-2.1-6 \
        software-properties-common  \
    && apt-add-repository -y ppa:bitcoin/bitcoin  \
    && apt-get update   \
    && apt-get install -y libdb4.8 libdb4.8++  \
    && apt-get remove --purge -y software-properties-common  \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/dynamic/dist:${PATH}"
COPY ./docker/configure.sh .
CMD ["/bin/bash","-c","./configure.sh && dynamicd --daemon && tail -f /dev/null"]