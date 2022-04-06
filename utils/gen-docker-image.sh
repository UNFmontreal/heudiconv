#!/bin/bash

set -eu

VER=$(grep -Po '(?<=^__version__ = ).*' ../heudiconv/info.py | sed 's/"//g')

image="kaczmarj/neurodocker:master@sha256:936401fe8f677e0d294f688f352cbb643c9693f8de371475de1d593650e42a66"

docker run --rm $image generate docker -b neurodebian:bullseye -p apt \
    --dcm2niix version=v1.0.20211006 method=source \
    --install git gcc pigz liblzma-dev libc-dev git-annex-standalone netbase \
    --copy . /src/heudiconv \
    --miniconda use_env=base conda_install="python=3.7 traits>=4.6.0 scipy numpy nomkl pandas" \
      pip_install="/src/heudiconv[all]" \
      pip_opts="--editable" \
    --entrypoint "heudiconv" \
> ../Dockerfile
