# Genversion 

Generate a semantic version from conventional commits in a git repository. 

Example:

1. A repository's latest tag is `1.2.3`.
2. A new commit message is made containing the first line:
    ```
    feat: Add a controller for sending a system notification
    ```
3. This script is executed in the local working branch and detects that the minor version should be increased. The program outputs a new version `1.3.0`.

## How it works

The version is calculated by analyzing the repository's commit message history between its last pushed semver tag and the current HEAD. The [Conventional Commits specification](https://www.conventionalcommits.org/) is used to calculate the next tag version based on flags in the commit message.

### Commit message flags

By design, commit message flags are case-insensitive, so `feat: ` and `FEAT: ` will both trigger a minor version bump. This is not true of a message footer's `BREAKING CHANGE: ` flag, which must always be uppercase.

### Version patterns

The latest repository tag must match the following [Semantic Versioning](https://semver.org/) patterns to infer the new version:

- 1.2.3
- 1.2.3+build.1.e012
- 1.2.3-rc.1

The "v" prefix is optional, so tags such as `v1.2.3` will also match. 

## Program output

The program runs in quiet mode by default and displays the final output as a semver tag in the form `1.2.3`.

If the remote repository isn't yet tagged, the default unstable tag `0.0.0` is assigned.

If no version change is required, an indicator (`===`) is printed to stdout.
