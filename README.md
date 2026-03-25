dockerfile and supporting scripts to run Steam in a container.

Tested on Debian with sway and pipewire/wireplumber

Adjust bind.sh to your particular environment so that the UID/GID is mapped correctly.

seccomp-steam.json is the default seccomp from [here](https://github.com/moby/profiles/blob/main/seccomp/default.json), with the following syscalls allowed:
- arch_prctl
- chroot
- kcmp
- mount
- pivot_root
- ptrace
- umount2
- unshare

Additionally, the following flags on clone() are allowed:
- CLONE_NEWNET
- CLONE_NEWNS
- CLONE_NEWPID
- CLONE_NEWUSER
