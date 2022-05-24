# V Rising Linux Dedicated Server Setup

This repo contains a set of utility scripts for installing VRisingServer (Steam AppID: 1829350) on a headless Ubuntu server.

## Initial steps

First some prerequisite packages are required:

```bash
dpkg --add-architecture i386
apt-get update
apt-get install git xvfb lib32gcc-s1 libc6:amd64 libc6:i386 libgl1-mesa-glx:i386
```

Then we need to create a user for running our server:

```bash
useradd -m -d /var/gamemaster -r gamemaster
```

Next, clone this repository into our new users home directory:

```bash
cd /var/gamemaster
runuser -u gamemaster -- git clone --depth 1 https://github.com/RamblingMadMan/VRisingProtonServer.git
cd VRisingProtonServer
```

And run the manager script:

```bash
bash manage.sh
```
