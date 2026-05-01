FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/GMT
ENV PATH="$PATH:/root/.local/bin"

# Keep track of which versions are end-of-life
# https://devguide.python.org/#status-of-python-branches
RUN apt-get update -qy && \
    apt-get install -qy --no-install-recommends \
    ca-certificates curl gnupg2 && \
    . /etc/os-release && \
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/deadsnakes.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt-get update -qy && apt-get upgrade -qy && \
    apt-get install -qy --no-install-recommends \
    git openssh-client \
    python3 python3-dev python3-pip python3-venv \
    python3.9 python3.9-distutils python3.9-venv python3.9-dev \
    python3.10 python3.10-dev python3.10-venv \
    python3.11 python3.11-dev python3.11-venv \
    python3.12 python3.12-dev python3.12-venv \
    python3.13 python3.13-dev python3.13-venv && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/cache/apt/lists && \
    apt-get autoclean && apt-get clean && \
    python3.12 -m venv .venv && \
    . .venv/bin/activate && \
    pip install pipx && \
    pipx ensurepath &&  \
    pipx install nox && \
    pipx install --preinstall nox-poetry poetry && \
    rm -rf .venv

# Install taskfile and uv
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /root/.local/bin && \
    curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/root/.local" INSTALLER_NO_MODIFY_PATH=1 sh
