dockerfile and supporting scripts to run Steam in a container.
Tested on Debian with sway and pipewire/wireplumber
Adjust bind.sh to your particular environment so that the UID/GID is mapped correctly.
seccomp-steam.json is the default seccomp from [here](github.com/moby/profiles/blob/main/seccomp/default.json) but with unconstrained clone()
