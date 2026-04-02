# Genversion

Generate a semantic version from conventional commits in a git repository.

Example:

1. A repository's latest tag is `1.2.3`.
2. A new commit message is made containing the first line:
   ```
   feat: Add a controller for sending a system notification
   ```
3. This script is executed in the local working branch and detects that the minor version should be increased. The program outputs a new version `1.3.0`.

_Note: a git remote must be configured to query the project's tag history._

## Running the program

Clone the project and copy its `bin/genversion` script to an environment-accessible `PATH` such as `/home/$USER/bin`. Make the file executable and source the shell's init script:

```sh
cp ./bin/genversion ~/bin
chmod 700 ~/bin/genversion
source ~/.bashrc # or .zshrc, etc.
```

Run the script from a git repository directory.

```sh
cd ~/projects/my-test-project-with-tags
genversion
```

### Docker-based execution

From the cloned project directory, build the container image:

```sh
docker build -t genversion:latest .
```

A git repository's root directory must be mounted and mapped to the container's `/app` directory when running the command.

```sh
cd ~/projects/my-test-project-with-tags
docker run --rm -v $(pwd):/app genversion:latest
```

Arguments (`-h`, `-u`, `-v`) may be passed to the container script:

```sh
docker run --rm -v $(pwd):/app genversion:latest -h
```

### Running in a pipeline

In pipeline environments that shallow-clone a repository by default, the latest remote tag may not be retrieved. Use the **unshallow** (`-u`) argument to fetch a project's history up to the maximum 32-bit integer size (2,147,483,647). Note that this is not the same as running `git fetch --unshallow`, and performance should be considered in large repositories.

### Program output

The program runs in quiet mode by default and displays the final output as a semver tag in the form `1.2.3`.

If the remote repository isn't yet tagged, the default unstable tag `0.0.0` is assigned.

If no version change is required, an indicator (`===`) is printed to stdout.

## How it works

The version is calculated by analyzing the repository's commit message history between its last pushed semver tag and the current HEAD. The [Conventional Commits specification](https://www.conventionalcommits.org/) is used to calculate the next tag version based on flags in the commit message.

### Commit message flags

By design, commit message flags are case-insensitive, so `feat:` and `FEAT:` will both trigger a minor version bump. This is not true of a message footer's `BREAKING CHANGE:` flag, which must always be uppercase.

### Version patterns

The latest repository tag must match the following [Semantic Versioning](https://semver.org/) patterns to infer the new version:

- 1.2.3
- 1.2.3+build.1.e012
- 1.2.3-rc.1

The "v" prefix is optional, so tags such as `v1.2.3` will also match.
