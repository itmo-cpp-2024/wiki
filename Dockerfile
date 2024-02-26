FROM ubuntu:23.10

RUN DEBIAN_FRONTEND=noninteractive    \
    apt-get update                 && \
    apt-get -y upgrade             && \
    apt-get -y install                \
    docker-buildx                     \
    git git-lfs                       \
    cmake gcc g++ clang               \
    python3-pip                       \
    clang-format clang-tidy           \
    curl

RUN pip install --break-system-packages conan

USER ubuntu
WORKDIR /home/ubuntu
