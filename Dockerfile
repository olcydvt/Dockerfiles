FROM        ubuntu:20.04
MAINTAINER  olcay

ENV DEBIAN_FRONTEND noninteractive

# update and install dependencies
RUN         apt-get update \
                && apt-get install -y \
                    software-properties-common \
                    wget \
                && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
                && apt-get update \
                && apt-get install -y \
                    make \
                    git \
                    curl \
                    vim \
                && apt-get install -y cmake \
                && apt-get install -y \
					build-essential \
					gcc-9 \
					g++-9 \
					gcc-9-multilib \
					g++-9-multilib \
					xutils-dev \
					patch \
					libgtk2.0-dev \
                                        cython python3-dev python-setuptools  python3-pip \
				&& apt-get install -y libstdc++-11-dev \
				&& apt-get install -y libboost-all-dev

RUN 		pip3 install conan==1.33.0			
RUN 		conan  profile new --detect default
RUN 		conan  profile update settings.compiler.libcxx=libstdc++11 default

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git clang make binutils autoconf automake autotools-dev libtool \
        pkg-config \
        zlib1g-dev libev-dev libjemalloc-dev ruby-dev libc-ares-dev bison \
        libelf-dev
	

RUN git clone --depth 1 -b OpenSSL_1_1_1m+quic https://github.com/quictls/openssl && \
    cd openssl && \
    ./config --openssldir=/etc/ssl && \
    make -j$(nproc) && \
    make install_sw && \
    cd .. && \
    rm -rf openssl

RUN git clone https://github.com/nghttp2/nghttp2
  cd nghttp2
  git submodule update --init
  autoreconf -i
  ./configure --enable-asio-lib --with-mruby --with-neverbleed --enable-http3 --with-libbpf \
      --disable-python-bindings \
      CC=clang-12 CXX=clang++-12 \
      PKG_CONFIG_PATH="$PWD/../openssl/build/lib/pkgconfig:$PWD/../nghttp3/build/lib/pkgconfig:$PWD/../ngtcp2/build/lib/pkgconfig:$PWD/../libbpf/build/lib64/pkgconfig" \
      LDFLAGS="$LDFLAGS -Wl,-rpath,$PWD/../openssl/build/lib -Wl,-rpath,$PWD/../libbpf/build/lib64"
  make -j$(nproc) \
  make install \
  cd .. && \
  rm -rf nghttp2
