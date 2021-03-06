FROM rust:1.50-buster

RUN rustup component add rustfmt rls rust-analysis rust-src && \
    cargo install cargo-edit

RUN mkdir -p /root/.cargo/bin && \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o /root/.cargo/bin/rust-analyzer

ENV PATH=/root/.cargo/bin:${PATH}

RUN apt-get update && \
    apt-get install -y emacs git

ARG emacs_home=/root/.emacs.d
ARG site_lisp=${emacs_home}/site-lisp
ARG dev_dir=/root/work

RUN mkdir ${emacs_home} && \
    mkdir ${site_lisp} && \
    mkdir ${dev_dir}

COPY init.el ${emacs_home}
RUN emacs --batch --load ${emacs_home}/init.el

WORKDIR /root
