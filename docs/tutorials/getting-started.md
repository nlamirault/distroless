# Getting started with Atoma

This tutorial will guide you through setting up your environment and building your first lightweight container image using Atoma's build system. We will build the `shell` image, which provides a secure base environment with common tools.

## Prerequisites

Before starting, ensure you have the following installed on your host machine:

- **Docker** (or another container runtime supported by apko)
- **Make**
- **Git**

## Step 1: Clone the repository

First, clone the Atoma repository and navigate to its root directory:

```bash
git clone https://github.com/nlamirault/atoma.git
cd atoma
```

## Step 2: Clean and prepare the build environment

Before starting, clean up any previous build outputs:

```bash
make clean
```

This removes any pre-existing TAR archives, SBOM JSON files, or local keys to ensure a clean build.

## Step 3: Build the Shell container image

We will use the Makefile to trigger an `apko` build inside a Docker container. Run the following command to build the production profile of the `shell` image:

```bash
make build-image IMAGE=images/shell
```

**What is happening?**
1. Since `images/shell` only has `apko` configs (`prod.yaml` / `dev.yaml`), `apko` is executed inside a docker container.
2. It fetches Wolfi packages defined in the configuration, resolves dependencies, and packs them into a root filesystem.
3. It outputs a tarball containing the container image at `images/shell/shell.tar`.

## Step 4: Load and test the image

Once built, verify the image by running the test suite target. The test suite loads the image tarball into your local Docker daemon and runs a basic sanity check:

```bash
make test IMAGE=images/shell
```

Expected output should indicate that the image loaded successfully and can execute basic command checks:

```text
[atoma] Test container image
Loaded image: shell:latest
```

## Next steps

- Learn more about the building workflows in [Build and test images](../how-to/howto-build.md).
- Understand how configurations are defined in [Configuration reference](../reference/configuration.md).
- Dive deep into how apko and Wolfi work together in [Architecture and design](../explanation/architecture.md).
