# Jon's DSC Collection

This repository holds some DSC files for a development environment.
It is always a work in progress and is being shared for convenience and so
other people can see how I'm using DSC.

## Dependencies

DSCv3 is required, but it's easy to install with WinGet:

```ps1
winget install --id Microsoft.DSC -e
```

Most of these configuration files lean on the `Microsoft.Windows/WindowsPowerShell`
resource, which uses WinRM. It is not enabled by default, but can be enabled
by running `boostrap.ps1` from this repository as an administrator.

## Applying the configuration

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
