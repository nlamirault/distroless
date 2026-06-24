# Configuration schema reference

Atoma uses two key configuration definitions to construct its secure base images: **apko** for image assembly and **melange** for package building.

## Apko configuration schema

An `apko` configuration (e.g. `prod.yaml`, `dev.yaml`) describes the target environment, package registry repos, security credentials, user accounts, target architectures, and standard metadata.

### Example block

```yaml
contents:
  keyring:
    - https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
  repositories:
    - https://packages.wolfi.dev/os
  packages:
    - bash
    - curl

accounts:
  groups:
    - groupname: nonroot
      gid: 65532
  users:
    - username: nonroot
      uid: 65532
      gid: 65532
  run-as: nonroot

work-dir: /home/nonroot

archs:
  - amd64
  - arm64

annotations:
  org.opencontainers.image.authors: "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
```

### Parameter description

- `contents.keyring`: List of URLs to public keys used to verify APK packages.
- `contents.repositories`: Repositories list from where APK packages are downloaded (e.g. Wolfi OS repository).
- `contents.packages`: List of packages to install in the container image.
- `accounts`: Configures user ID (UID) and group ID (GID) mappings.
  - `run-as`: Specifies the default user context executing inside the container (defaults to `nonroot` for security).
- `work-dir`: The default working directory for the runtime container.
- `archs`: List of CPU architectures to compile for (multi-arch output).
- `annotations`: Open Container Initiative (OCI) metadata mapping.

---

## Melange configuration schema

A `melange.yaml` file defines how to build an APK package from source code or binaries (useful when Wolfi does not package a dependency natively).

### Example structure

```yaml
package:
  name: jsonnet-bundler
  version: 0.6.0
  epoch: 0
  description: "Jsonnet package manager"
  target-architecture:
    - all
  copyright:
    - license: Apache-2.0

environment:
  contents:
    keyring:
      - https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
    repositories:
      - https://packages.wolfi.dev/os
    packages:
      - ca-certificates-bundle
      - go

pipeline:
  - uses: git-checkout
    with:
      repository: https://github.com/jsonnet-bundler/jsonnet-bundler
      tag: v0.6.0
  - runs: |
      make jsonnet-bundler
  - uses: strip
```

### Parameter description

- `package`: Standard metadata for the generated APK package (name, version, epoch, description, license).
- `environment`: The build-time dependencies needed to compile the package (e.g., compilers like `go`, `rust`, or utilities like `git`).
- `pipeline`: A sequence of steps (actions or shell scripts) executed in a clean environment to check out source code, compile the program, and package target binaries.
