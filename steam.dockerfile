FROM ubuntu:24.04 AS xwayland-satellite-build
RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        clang \
        git \
        gnupg \
        libclang-20-dev \
        libxcb-composite0-dev \
        libxcb-cursor-dev \
        libxcb-icccm4-dev \
        libxcb-res0-dev \
        libxcb-util-dev \
        pkg-config
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"
RUN git clone https://github.com/Supreeeme/xwayland-satellite
WORKDIR /xwayland-satellite
RUN cargo build --release

FROM ubuntu:24.04 AS steam-base
COPY --from=xwayland-satellite-build /xwayland-satellite/target/release/xwayland-satellite /usr/local/bin
RUN apt-get update \
    && apt-get install -y \
        curl \
        ca-certificates \
        gnupg
RUN curl -fsSL https://repo.steampowered.com/steam/archive/stable/steam.gpg \
    -o /usr/share/keyrings/steam.gpg
RUN tee /etc/apt/sources.list.d/steam-stable.list <<'EOF'
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
deb-src [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
EOF
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        dbus \
        dbus-x11 \
        libgl1-mesa-dri:amd64 \
        libgl1-mesa-dri:i386 \
        libglx-mesa0:amd64 \
        libglx-mesa0:i386 \
        libgtk2.0-0t64:i386 \
        libpipewire-0.3-0:i386 \
        libxcb-cursor0 \
        libxcb-res0:i386 \
        libxi6:i386 \
        libxrandr2:i386 \
        libxtst6:i386 \
        mesa-vulkan-drivers \
        steam-launcher \
        xwayland

RUN groupadd -g 992 -U ubuntu render # create standard render group
RUN mkdir -p /run/user/1000 /tmp/.X11-unix
RUN chown ubuntu:ubuntu /run/user/1000
RUN chmod 777 /tmp/.X11-unix

RUN tee /usr/local/bin/entrypoint.sh <<'EOF'
#!/bin/bash
rm -f /tmp/.X0-lock
export DISPLAY=:0
xwayland-satellite $DISPLAY &
dbus-run-session -- steam "$@"
EOF
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
