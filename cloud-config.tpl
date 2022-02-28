#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
apt:
  sources:
    docker.list:
      source: deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
packages:
- ca-certificates
- containerd.io
- curl
- docker-ce
- docker-ce-cli
- gnupg
- lsb-release
- uidmap
groups:
- docker
users:
- name: ubuntu
  lock_passwd: true
  shell: /bin/bash
  ssh_authorized_keys:
%{ for key in public_keys ~}
  - ${key}
%{ endfor ~}
  groups:
  - docker
  - sudo
  sudo:
  - ALL=(ALL) NOPASSWD:ALL
- name: tunnel
  lock_passwd: true
  shell: /usr/sbin/nologin
  ssh_authorized_keys:
%{ for key in tunnel_keys ~}
  - ${key}
%{ endfor ~}
write_files:
- encoding: b64
  content: ${setup_sha512}
  owner: root:root
  path: /etc/setup-sha512
- content: net.ipv4.ip_unprivileged_port_start=80
  path: /etc/sysctl.d/unprivileged_port_start.conf
- encoding: b64
  content: ${setup_sh}
  owner: root:root
  path: /usr/local/sbin/setup.sh
  permissions: '0755'
ssh_genkeytypes: ed25519
ssh_keys:
  ed25519_private: |
    ${ed25519_private}
  ed25519_public: ${ed25519_public}
runcmd:
- systemctl disable --now docker.service docker.socket
- loginctl enable-linger ubuntu
# These are super ugly, but there seem to be no module for defining directories...
%{ for dir in data_dirs ~}
- mkdir -m 0770 -p /data/${dir}
- chown ubuntu:ubuntu /data/${dir}
%{ endfor ~}
- su - ubuntu -c '/usr/local/sbin/setup.sh'
fs_setup:
- label: data
  filesystem: 'ext4'
  device: /dev/vdb
  overwrite: false
mounts:
- ['LABEL=data', /data, "ext4", "defaults"]
