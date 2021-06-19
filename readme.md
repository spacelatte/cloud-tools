
# cloud-tools

A simple binary manager for cloud utilities

## Quick Start

- Clone the repository, `cd` into it.
- Run `make`
- This will prompt you to add `$(pwd)/bin` into your `$PATH`
  + Eg: `PATH="$(pwd)/bin:${PATH}"`

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


