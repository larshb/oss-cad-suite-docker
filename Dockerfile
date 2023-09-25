FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update
RUN apt -y upgrade
RUN apt -y install bc unzip rsync bison flex gawk git pkg-config \
        python3 python3-cairo python3-cairo-dev adwaita-icon-theme-full cmake \
        wget gperf autoconf curl pax-utils qt5-qmake qtbase5-dev-tools \
        libtool llvm default-jre
RUN apt -y autoremove
RUN rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME /opt/rust/rustup
ENV PATH ${PATH}:/opt/rust/cargo/bin
RUN curl https://sh.rustup.rs -sSf | RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -s -- --default-toolchain stable --profile default --no-modify-path -y

ARG RELEASE_TGZ
ADD ${RELEASE_TGZ} /opt/
ENV PATH "/opt/oss-cad-suite/bin:$PATH"

ENV force_color_prompt yes

WORKDIR /work
ENTRYPOINT [ "/bin/bash" ]
