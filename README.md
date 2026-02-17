# taxifolia-router-config

Most of my configuration files for my Router based on [Taxifolia](https://github.com/tulilirockz/taxifolia)!

This sets up a gateway router using [pppd](http://www.samba.org/ppp), [systemd-networkd](https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html) and firewalld, with [`unbound`](https://nlnetlabs.nl/projects/unbound/) from a [quadlet](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) on [Marmorata](https://github.com/tulilirockz/marmorata) as the DNS resolver by redirecting ports using firewalld forwarding.

The complete deployment for this project is by using Taxifolia + Marmorata (for unbound) + this as a confext configuration.

## Confext

This repository is meant to be deployed as a [systemd-confext](https://www.freedesktop.org/software/systemd/man/latest/systemd-confext.html#) extension, you can generate it with:

```bash
just configure # WIP, not implemented yet. This is supposed to change a few predefined values using a `.env` file.
```

```bash
just generate-confext
```

Then you can deploy by running:
```bash
just install
```

The installation procedure is particularly simple so you can just run the command directly on your deployment instead.

These were partially based on <https://eldon.me/arch-linux-based-home-router-part-iii-firewalld-configuration/>
