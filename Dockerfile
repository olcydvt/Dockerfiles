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
				&& apt-get install -y libstdc++-11-dev \
				&& apt-get install -y python3-pip

RUN 		pip3 install conan==1.33.0			
RUN 		conan  profile new --detect default
RUN 		conan  profile update settings.compiler.libcxx=libstdc++11 default
