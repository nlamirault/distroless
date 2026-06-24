# Atoma Documentation

**Atoma** is a set of lightweight and secure container images based on the [Wolfi](https://wolfi.dev/) Linux distribution. It uses [apko](https://github.com/chainguard-dev/apko) and [melange](https://github.com/chainguard-dev/melange) to build minimal, distroless images that reduce security attack surfaces.

This documentation is organized into four sections according to the [Diátaxis](https://diataxis.fr/) framework to match different user needs.

---

## Tutorials — learning by doing

Start here if you are new to Atoma and want to build your first container image.

| Document | Description |
| --- | --- |
| [Getting started](tutorials/getting-started.md) | Set up tools and build your first container image locally |

---

## How-to guides — solving specific problems

Use these guides to perform common development and operations tasks.

| Document | Description |
| --- | --- |
| [Build and test images](how-to/howto-build.md) | How to build dev/prod profiles and test or scan local images |
| [Verify images](how-to/howto-verify.md) | How to verify build provenance, signatures, and SBOMs using `cosign` and `gh` |

---

## Reference — technical specifications

Consult these for detailed lists, configuration options, and command options.

| Document | Description |
| --- | --- |
| [Configuration](reference/configuration.md) | Schema structure for `apko` and `melange` configurations |
| [Makefile commands](reference/makefile.md) | List of make targets for building, scanning, and cleaning images |

---

## Explanation — understanding the design

Read these to understand the architectural principles, choices, and concepts behind Atoma.

| Document | Description |
| --- | --- |
| [Architecture and design](explanation/architecture.md) | Why Wolfi and apko/melange? How distroless enhances supply-chain security |
