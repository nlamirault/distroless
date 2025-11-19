# infra-tools

This image contains infrastructure tools for cloud-native development and
operations.

## Included Tools

- **AWS CLI v2** - Amazon Web Services command line interface
- **Cosign** - Container signing and verification
- **Crane** - Container registry manipulation
- **Docker CLI** with Buildx - Container building and management
- **Git** - Version control system
- **Grype** - Vulnerability scanner
- **Helm** with Helm Docs - Kubernetes package manager
- **jq/yq** - JSON/YAML processors
- **jsonnet-bundler (jb)** - Jsonnet package manager
- **kubectl** - Kubernetes command line tool
- **Kustomize** - Kubernetes configuration management
- **OpenTofu** - Infrastructure as Code tool
- **OpenSSH Client** - Secure shell client
- **OpenSSL** - Cryptography toolkit

## Versions

| 📌 Version   | ⬇️ Pull URL                                             |
| ------------ | ------------------------------------------------------ |
| latest       | ghcr.io/nlamirault/distroless/infra-tools:latest       |
| latest-shell | ghcr.io/nlamirault/distroless/infra-tools:latest-shell |
| latest-dev   | ghcr.io/nlamirault/distroless/infra-tools:latest-dev   |

## ✅ Verify the Build Provenance

### Using Github CLI

GitHub CLI ([gh](https://cli.github.com/)) can be used to retrieve the build
provenance, which details the exact commit, workflow, and runner that produced
the image:

- **Production image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/infra-tools:latest
```

- **Shell image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/infra-tools:latest-shell
```

- **Dev image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/infra-tools:latest-dev
```

### Using Cosign

- **Production image**

```shell
cosign verify-attestation \
 --type slsaprovenance \
 --certificate-oidc-issuer https://token.actions.githubusercontent.com \
 --certificate-identity-regexp '^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
 ghcr.io/nlamirault/distroless/infra-tools:latest@sha256:xxxxxx
```

- **Shell image**

```shell
cosign verify-attestation \
  --type slsaprovenance \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
  ghcr.io/nlamirault/distroless/infra-tools:latest-shell@sha256:xxxxx
```

- **Dev image**

```shell
cosign verify-attestation \
  --type slsaprovenance \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v[0-9]+.[0-9]+.[0-9]+$' \
  ghcr.io/nlamirault/distroless/infra-tools:latest-dev@sha256:xxxxxx
```

## ✅ Verify the Image Signature

All official images are **cryptographically signed** using
[Sigstore Cosign](https://www.sigstore.dev/).

To ensure the image is authentic and has not been tampered with, use the
following command:

- **Production image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/infra-tools.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/infra-tools:latest | jq
```

- **Shell image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/infra-tools:latest-shell | jq
```

- **Dev image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/infra-tools:latest-dev | jq
```

## ✅ Verify the Image Attestations

To enhance transparency, we generate SBOMs for each release. SBOMs are available
directly from the container registry and can be verified using using
[Sigstore Cosign](https://www.sigstore.dev/).

- **Production image**

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/infra-tools:latest
```

- **Shell image**

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/infra-tools:latest-shell
```

This will pull in the signature for the attestation specified by the --type
parameter, which in this case is the SPDX attestation. You will receive output
that verifies the SBOM attestation signature in cosign's transparency log:

## 📦 Download the Image SBOM Attestations

To download an attestation, use the `cosign` download attestation command and
provide both the predicate type and the build platform. For example, the
following command will obtain the SBOM for the python image on `linux/amd64`:

- **Production image**

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/distroless/infra-tools:latest | jq -r .payload | base64 -d | jq .predicate
```

- **Shell image**

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/distroless/infra-tools:latest-shell | jq -r .payload | base64 -d | jq .predicate
```
