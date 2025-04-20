# Windows Development Environment

This repository holds a configuration for a development environment. It is always
a work in progress.

Apply the configuration using `winget`.

## Enable DSC

The `winget configure` feature must be enabled before configurations can be applied.

```ps1
winget configure --enable
```

## Apply configuration

The first time `winget` is used, there are agreements that have to be accepted.
They can be accepted automatically with command line options like this:

```ps
winget configure --accept-configuration-agreements --disable-interactivity -f base.winget
```

Alternatively, the configuration can be applied with a simpler command that might
result in prompts to accept agreements like this:

```ps1
winget configure base.winget
```

To update all packages without altering the list of installed packages:

```ps1
winget update --all
```
