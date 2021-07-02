
# cloud-tools

A simple binary manager for cloud utilities

## Quick Start

- Clone the repository, `cd` into it.
- Run `make`
- This will prompt you to add `$(pwd)/bin` into your `$PATH`
  + Eg: `PATH="$(pwd)/bin:${PATH}"`

### Completions

You can enable shell completions by

```bash
source <(make -C /path/to/this/repo completions)
```

> PS: Add it to `~/.profile` or `~/.bashrc`.

### Extras

You can install plugins via `krew` or `kubectl krew`
- `make extras` will install a few plugins that was useful to me.

## Authentication

Authentication is handled by `git` command-line utility, you need to set your
GitHub username and PAT (Personal Access Token).

```bash
git config github.user {github_username}
git config github.pat {your_access_token}
```

You can verify it by: `git config --get-regexp ^github`

## List of tools & utilities

You can see them by executing: `make list`

Downloadable binaries' archive are also available in
[Releases](../../releases) section.

## Cleaning up

- Remove dangling links: `make prune`
- Remove everything: `make clean`
