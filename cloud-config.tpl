#cloud-config
write_files:
- encoding: b64
  content: ${setup_sha512}
  owner: root:root
  path: /etc/setup-sha512
ssh_genkeytypes: ed25519
ssh_keys:
  ed25519_private: |
    ${ed25519_private}
  ed25519_public: ${ed25519_public}
