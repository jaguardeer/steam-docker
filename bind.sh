#!/bin/bash
umount -qf pipewire-socket wayland-socket pulse
#mkdir -p ./pulse
#touch ./pipewire-socket ./wayland-socket
mount --bind --map-users 1000:100999:1 --map-groups 1000:100999:1 "/run/user/1000/pipewire-0" ./pipewire-socket
mount --bind --map-users 1000:100999:1 --map-groups 1000:100999:1 "/run/user/1000/pulse" ./pulse
mount --bind --map-users 1000:100999:1 --map-groups 1000:100999:1 "/run/user/1000/wayland-1" ./wayland-socket 
setfacl -m g:100043:rw /dev/dri/card0
setfacl -m g:100991:rw /dev/dri/renderD128
