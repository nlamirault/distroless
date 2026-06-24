# How to build and test images

This guide outlines how to build different image profiles (production, development, shell), generate Software Bill of Materials (SBOMs), scan for vulnerabilities, and package custom APKs using melange.

## Build profiles

Atoma supports three primary build profiles for images, defined by YAML configurations:

| Profile | Config File | Make Command | Purpose |
| --- | --- | --- | --- |
| **Production** | `prod.yaml` | `make build-image IMAGE=...` | Minimal container image optimized for security and size. |
| **Development** | `dev.yaml` | `make build-dev-image IMAGE=...` | Includes debugging tools, shells, and extra packages. |
| **Shell** | `shell.yaml` | `make build-shell-image IMAGE=...` | Alternative profile tailored with shell environments. |

### Build all profiles at once

To build production, development, and shell profiles in one command:

```bash
make build-all IMAGE=images/infra-tools
```

---

## Building custom APK packages with melange

When an image directory includes a `melange.yaml` file (such as in `images/infra-tools`), a custom APK package must be built before compiling the image.

The build process is automated:
1. `make build-image` detects `melange.yaml`.
2. It executes `melange keygen` if no key exists in `${PWD}/keys/melange.rsa`.
3. It builds the package in a local directory using the `cgr.dev/chainguard/melange` container.
4. `apko` consumes the package from the local packages repository `--build-repository-append /work/packages`.

To manually trigger only the APK build:

```bash
make build-apk IMAGE=images/infra-tools
```

---

## Test and inspect images

Once an image has been compiled into a `.tar` archive under its subdirectory (e.g., `images/shell/shell.tar`), you can run the following targets:

### Run basic verification tests

```bash
make test IMAGE=images/shell
```

This loads the tarball into Docker and runs `--version` tests to ensure the binaries work.

### Scan images for vulnerabilities

Atoma uses [Grype](https://github.com/anchore/grype) to check images for security vulnerabilities:

```bash
make scan IMAGE=images/infra-tools
```

### Generate SBOMs (Software Bill of Materials)

Atoma uses [Syft](https://github.com/anchore/syft) to produce comprehensive SBOMs in both SPDX and CycloneDX formats:

```bash
make sbom IMAGE=images/infra-tools
```

This creates two files in your current working directory:
- `sbom-<image-name>.json` (SPDX format)
- `sbom-<image-name>.cdx` (CycloneDX format)

---

## Cleaning build artifacts

To clean up all local build cache, tarballs, generated keys, SBOMs, and local packages, run:

```bash
make clean
```
