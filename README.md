# V Rising Linux Dedicated Server Setup

> **WARNING** This is all highly experimental. Until Stunlock Studios releases an official linux dedicated server, this is a quick and dirty substitute with no guarantee it won't blow up.

This repo contains a set of utility scripts for installing VRisingServer (Steam AppID: 1829350) on a headless Ubuntu server.

## Initial steps

### Prerequisite packages

First some prerequisite packages are required:

```bash
dpkg --add-architecture i386
apt-get update
apt-get install git xvfb lib32gcc-s1 libc6:amd64 libc6:i386 libgl1-mesa-glx:i386
```

### Firewall rules

On a fresh install of Ubuntu it is **highly** recommended to run these commands as root:

```bash
ufw allow OpenSSH
ufw allow 9876/udp
ufw allow 9877/udp
ufw allow 9090
ufw enable
```

This allows all the required ports through `ufw` then enables it.

### Server setup

Now we need to create a user for running our game server:

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
