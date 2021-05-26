# Push changes to AUR action

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/datakrama/push-aur-action/CI?label=CI&style=flat-square)](https://github.com/datakrama/push-aur-action/actions) [![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/datakrama/push-aur-action?style=flat-square)](https://github.com/datakrama/push-aur-action/releases) [![GitHub](https://img.shields.io/github/license/datakrama/push-aur-action?style=flat-square)](LICENSE)

This action allows pushing changes made by git to [AUR](https://aur.archlinux.org/). Yup, just that.

If you need make changes to your AUR package (and test it), you can use [archlinux-package-action](https://github.com/datakrama/archlinux-package-action).

This action is very inspired by [KSXGitHub/github-actions-deploy-aur](https://github.com/KSXGitHub/github-actions-deploy-aur).

> Put your private SSH key to internet is not recommended. When using this, you are fully responsible for the actions you take and all the possibilities that will occur.

## Usage
### Requirement
- Use [actions/checkout](https://github.com/actions/checkout) in previous step. This is important, unless you want your [$GITHUB_WORKSPACE](https://docs.github.com/en/actions/reference/environment-variables#default-environment-variables) folder to be empty.
### Customizing
Following inputs can be used as `step.with` keys.

| Name                  | Type      | Default                       | Required  | Description                           |
|-----------------------|-----------|-------------------------------|-----------|---------------------------------------|
| `path`                | String    |                               | `false`   | Location for this action to run. This path always located under $GITHUB_WORKSPACE |
| `pkgname`             | String    |                               | `true`    | AUR package / repository name         |
| `git_username`        | String    |                               | `true`    | The user name for git config          |
| `git_email`           | String    |                               | `true`    | The user email for git config         |
| `private_ssh_key`     | String    |                               | `true`    | Your private ssh key with access to AUR repository |
| `ssh_keyscan_types`   | String    | rsa,dsa,ecdsa,ed25519         | `false`   | Comma-separated list of keyscan types to use when adding aur.archlinux.org to known hosts|
| `push`                | Boolean   | `true`                        | `false`   | Leave this `false` will disable push command, useful if you only want to test the SSH connection. |
| `force`               | Boolean   | `true`                        | `false`   | Use `--force` flag when push to AUR.  |   

### Examples

```yaml
name: CI

on:
  push:
    branches: main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Push changes to AUR
        uses: datakrama/push-aur-action@v1
        with:
          pkgname: 'nonicons-font'
          git_username: ${{ secrets.GIT_USERNAME }}
          git_email: ${{ secrets.GIT_EMAIL }}
          private_ssh_key: ${{ secrets.AUR_PRIVATE_SSH_KEY }}
```

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)
