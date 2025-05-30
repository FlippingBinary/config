#!/usr/bin/env sh

# Exit early if not running in WSL
if ! grep -qEi "(Microsoft|WSL)" /proc/version; then
  echo "SSH-agent forwarding is for WSL environments."
  return
fi

# Ensure ~/.ssh directory exists
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
fi

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

# Exit if valid socket already exists
if ss -a | grep -q "$SSH_AUTH_SOCK"; then
  return
fi

# Remove any stale file
rm -f "$SSH_AUTH_SOCK"

# Exit if socat is not available
if ! command -v socat >/dev/null 2>&1; then
  echo "SSH-agent forwarding depends on socat, which is missing."
  echo "To install it, try:"
  echo "  sudo apt install socat"
  return
fi

# Exit if interop is disabled
if grep -qEi '^\s*\[interop\]' /etc/wsl.conf 2>/dev/null; then
  if grep -qEi '^\s*enabled\s*=\s*false' /etc/wsl.conf 2>/dev/null; then
    echo "SSH-agent forwarding depends on interop, which is disabled."
    echo "Please enabled it and try again. For more information, see:"
    echo "  https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings"
    return
  fi
fi

# Exit if npiperelay.exe is not available
if ! command -v npiperelay.exe >/dev/null 2>&1; then
  echo "SSH-agent forwarding depends on npiperelay.exe, which is missing."
  echo "To install it, try:"
  echo "  winget.exe install --id jstarks.npiperelay --exact"
  return
fi

# Start socat bridge to Windows OpenSSH agent
# Source: https://dev.to/andrewdoesinfra/using-windows-ssh-agent-in-wsl2-a-complete-guide-50oi
socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
  EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork \
  >/dev/null 2>&1 &

