#-------------------------------------------------------------------------------
# Atmel WinCUPL Devcontainer
# Copyright © 2025 islandcontroller and contributors
#-------------------------------------------------------------------------------

# Base image: Ubuntu Dev Container
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Root user for dependencies setup
USER root

# Dependencies setup
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ttf-mscorefonts-installer fontconfig \
    wine winetricks wine32:i386 \
    && rm -rf /var/lib/apt/lists/*

# Drop back to user
WORKDIR /tmp
USER vscode

#- Wine ------------------------------------------------------------------------
ENV WINEARCH=win32
ENV WINEPREFIX=/home/vscode/.wine
RUN wine wineboot && \
    winetricks mfc40

#- WinCUPL ---------------------------------------------------------------------
ARG WINCUPL_URL="https://ww1.microchip.com/downloads/en/DeviceDoc/awincupl.exe.zip"
ARG WINCUPL_HASH="45b4f911f7c73668dbef8650b6fa2ab0d106ff2b644640e92f12a7703fa52f51"

# Add setup data
COPY --chown=vscode setup.iss setup.reg /tmp/

# Download and install
RUN curl -sLO ${WINCUPL_URL} && \
    echo "${WINCUPL_HASH} $(basename ${WINCUPL_URL})" | sha256sum -c - && \
    unzip $(basename ${WINCUPL_URL}) awincupl.exe && \
    wine awincupl.exe /S && \
    before=$(stat -c '%Y' ${WINEPREFIX}/user.reg) && \
    wine regedit /tmp/setup.reg && \
    while [ $(stat -c '%Y' ${WINEPREFIX}/user.reg) = $before ]; do sleep 1; done && \
    rm $(basename ${WINCUPL_URL}) awincupl.exe setup.reg setup.iss

# Setup env vars
ENV LIBCUPL="C:\\Wincupl\\Shared\\Atmel.dl"

#- Redirection setup -----------------------------------------------------------
USER root
COPY wincupl /usr/bin/
RUN ln -s /usr/bin/wincupl /usr/bin/cupl && \
    ln -s /usr/bin/wincupl /usr/bin/csim && \
    ln -s /usr/bin/wincupl /usr/bin/winsim

#- User setup ------------------------------------------------------------------
# Go back to workspaces dir
USER vscode
VOLUME [ "/workspaces" ]
WORKDIR /workspaces