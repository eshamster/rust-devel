# Dockerfile: rust-devel

A Dockerfile to configure Rust development environment with Emacs.

## Installation

```bash
$ docker pull eshamster/rust-devel
$ docker run -v <a host folder>:/root/work -it eshamster/rust-devel /bin/sh
```

## Description

This mainly consists of ...

- Based on the official image of Rust (buster)
- Emacs 26 with LSP

---------

## Author

eshamster (hamgoostar@gmail.com)

## Copyright

Copyright (c) 2021 eshamster (hamgoostar@gmail.com)

## License

Distributed under the MIT License
