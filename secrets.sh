#!/usr/bin/env sh

if ! command -v keepassxc-cli >/dev/null 2>&1; then
  echo "Error: KeePassXC must be installed for this to work!" >&2
  echo "Hint: Install it with 'sudo apt install keepassxc'." >&2
  exit 1
fi

if [ ! -f "$KEEPASSXC_DB" ]; then
  echo "Error: KEEPASSXC_DB must be set to the path of the KeePassXC password database." >&2
  echo "Hint: Insert 'export KEEPASSXC_DB=\"/path/to/keepassxc.kdbx\" in \"$HOME/.profile\" or similar."
  exit 1
fi

keepassxc-cli show -a password "$KEEPASSXC_DB" "Ansible Vault"
