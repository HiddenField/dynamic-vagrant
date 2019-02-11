FROM ubuntu:bionic as build-env
WORKDIR /dynamic
RUN apt-get -qq update
RUN apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libcrypto++-dev libevent-dev software-properties-common git curl
RUN apt-add-repository -y ppa:bitcoin/bitcoin
RUN apt-get update -y 
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
COPY ./apps/dynamic-private/depends /dynamic/build/apps/dynamic-private/depends
WORKDIR /dynamic/build/apps/dynamic-private/depends
RUN make NO_QT=1 HOST=x86_64-unknown-linux-gnu
COPY ./apps/dynamic-private /dynamic/build/apps/dynamic-private
WORKDIR /dynamic/build/apps/dynamic-private
ENV PATH=/dynamic/build/apps/dynamic-private/depends/x86_64-unknown-linux-gnu/native/bin:${PATH}
ENV INSTALLPATH=/dynamic/build/apps/dynamic-private/installed/x86_64-unknown-linux-gnu
RUN mkdir -p ${INSTALLPATH}/bin
RUN mkdir -p ${INSTALLPATH}/include
RUN mkdir -p ${INSTALLPATH}/lib
RUN ./autogen.sh 
RUN ./configure --without-gui --disable-tests --disable-bench --prefix=/dynamic/build/apps/dynamic-private/depends/x86_64-unknown-linux-gnu --bindir=${INSTALLPATH}/bin --includedir=${INSTALLPATH}/include --libdir=${INSTALLPATH}/lib --disable-ccache --disable-maintainer-mode --disable-dependency-tracking --disable-shared --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
RUN make ${MAKEOPTS}
RUN make install-strip
RUN strip /dynamic/build/apps/dynamic-private/installed/x86_64-unknown-linux-gnu/bin/dynamicd
RUN strip /dynamic/build/apps/dynamic-private/installed/x86_64-unknown-linux-gnu/bin/dynamic-cli 
FROM ubuntu:bionic
WORKDIR /dynamic
COPY --from=build-env /dynamic/build/apps/dynamic-private/installed/x86_64-unknown-linux-gnu/bin/dynamicd /dynamic/build/apps/dynamic-private/installed/x86_64-unknown-linux-gnu/bin/dynamic-cli ./dist/
ENV PATH="/dynamic/dist:${PATH}"
COPY ./docker/* ./
CMD ["/bin/bash","-c","./entry.sh"]