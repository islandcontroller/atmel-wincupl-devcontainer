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
COPY setup.iss setup.reg /tmp/

# Download and install
RUN curl -sLO ${WINCUPL_URL} && \
    unzip awincupl.exe.zip awincupl.exe && \
    chmod +x awincupl.exe && \
    wine awincupl.exe /S && \
    before=$(stat -c '%Y' ${WINEPREFIX}/user.reg) && \
    wine regedit /tmp/setup.reg && \
    while [ $(stat -c '%Y' ${WINEPREFIX}/user.reg) = $before ]; do sleep 1; done && \
    rm awincupl.exe.zip awincupl.exe

# Setup env vars
ENV LIBCUPL="C:\\Wincupl\\Shared\\Atmel.dl"

# Add redirecting scripts
COPY cupl csim wincupl winsim /usr/bin/

#- User setup ------------------------------------------------------------------
# Go back to workspaces dir
VOLUME [ "/workspaces" ]
WORKDIR /workspaces