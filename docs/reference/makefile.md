# Makefile commands reference

This reference guide documents all commands exposed by the root [Makefile](../../Makefile) of the project.

Every command that requires an image name expects the environment variable `IMAGE` to point to the image subdirectory (for example, `IMAGE=images/shell` or `IMAGE=images/infra-tools`).

| Command | Description |
| --- | --- |
| `make clean` | Removes local build files, generated RSA keys, local package caches (`packages/`), tarballs, and SBOMs. |
| `make check` | Validates that requirements (such as Docker daemon availability) are satisfied. |
| `make build-apk` | Builds custom APK packages using Docker and `melange` if a `melange.yaml` exists in the target image path. |
| `make build-image` | Builds a production-ready container image (`prod.yaml`) using `apko`. Triggers APK builds first if required. |
| `make build-dev-image` | Builds a development container image (`dev.yaml`) using `apko`. |
| `make build-shell-image` | Builds a shell container image (`shell.yaml`) using `apko`. |
| `make build-all` | Compiles the custom APK, then builds the production, development, and shell container images consecutively. |
| `make test` | Loads the compiled `.tar` image archive into your local Docker daemon and runs execution health-checks. |
| `make scan` | Inspects the compiled container image using `grype` to discover any software vulnerabilities (CVEs). |
| `make sbom` | Generates a Software Bill of Materials (SBOM) in SPDX and CycloneDX formats using `syft`. |
