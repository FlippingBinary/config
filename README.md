# Jon's Configuration Collection

This repository holds some configuration files for a development environment and
home lab. It is always a work in progress and is being shared for my own convenience
and also to get feedback from others. If it helps someone else, I'd love to hear
about it!

> [!NOTE]
> I'm in the middle of consolidating my development workstation DSC files with
> an Ansible playbook previously used only for homelab configuration. The end
> goal is an Ansible-only configuration for every system I control. The downside
> is that I can't configure a system directly from this repository -- first it
> has to be setup for remote access by an Ansible controller, then that controller
> has to configure the system.

## Ansible

Secrets are protected by a password that is stored in a KeePassXC database. The
`secrets.sh` script has to be made executable, then it can be used as the password
file when using Ansible. When used correctly, KeePassXC will prompt for the database
password, which will unlock the vault password.

- Create new secrets (assuming the plaintext file `secrets.yml` already exists):

```shell
ansible-vault create secrets.yml --vault-password-file secrets.sh
```

- Edit secrets:

```shell
ansible-vault edit secrets.yml --vault-password-file secrets.sh
```

- Run playbook with secrets unlocked:

```shell
ansible-playbook --vault-password-file secrets.sh main.yml
```

- Run playbook with secrets unlocked on just the local host:

```shell
ansible-playbook -i inventory.yml -l cougar-wsl -e ansible_connection=local --vault-password-file secrets.sh main.yml
```

## DSC

### Dependencies

DSCv3 is required for the files under the `dsc` folder, but it's easy to install
with WinGet:

```ps1
winget install --id Microsoft.DSC -e
```

Most of these configuration files lean on the `Microsoft.Windows/WindowsPowerShell`
resource, which uses WinRM. It is not enabled by default, but can be enabled
by running `boostrap.ps1` from this repository as an administrator.

### Applying the configuration

The configuration files all require an elevated terminal, so open Windows
Terminal as administrator before applying them. The notable exception is
`home.dsc.yaml`, which clones a repository for NeoVim configuration. If that
repository is cloned by the administrator, there will be problems using it
as an unprivileged user. For that reason, it won't allow the administrator
to run it.

| Computer | RunAs | Command |
| -------- | ---- | ------- |
| Office   | Admin | `dsc config set --file .\office.dsc.yaml` |
| Tablet | Admin | `dsc config set --file .\tablet.dsc.yaml` |
| Office | Jon | `dsc config set --file .\home.dsc.yaml` |

*Obviously, these configurations are tailored to me, so don't use them
without making changes to these files to meet your own needs.*
