# Nginx

Minimal Wolfi-based nginx HTTP, reverse proxy, mail proxy, and a generic TCP/UDP
proxy server

| 📌 Version   | ⬇️ Pull URL                                       |
| ------------ | ------------------------------------------------ |
| latest       | ghcr.io/nlamirault/distroless/nginx:latest       |
| latest-dev   | ghcr.io/nlamirault/distroless/nginx:latest-dev   |
| latest-shell | ghcr.io/nlamirault/distroless/nginx:latest-shell |
| 1.27         | ghcr.io/nlamirault/distroless/nginx:1.27         |
| 1.27-dev     | ghcr.io/nlamirault/distroless/nginx:1.27-dev     |
| 1.27-shell   | ghcr.io/nlamirault/distroless/nginx:1.27-shell   |

## ✅ Check version

```sh
❯ docker run --rm --entrypoint /usr/sbin/nginx ghcr.io/nlamirault/distroless/nginx:1.27 -v
...
nginx version: nginx/1.27.4
❯ docker run --rm --entrypoint /usr/sbin/nginx ghcr.io/nlamirault/distroless/nginx:1.27-shell -v
...
nginx version: nginx/1.27.4
```

## ✅ Verify the Provenance

GitHub CLI ([gh](https://cli.github.com/)) can be used to retrieve the build
provenance, which details the exact commit, workflow, and runner that produced
the image:

- **Production image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/nginx:latest
```

- **Shell image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/nginx:latest-shell
```

- **Dev image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/distroless/nginx:latest-dev
```

## 📦 **Image Verification**

All official images are **cryptographically signed** using
[Sigstore Cosign](https://www.sigstore.dev/).

### ✅ Verify the Image Signature

To ensure the image is authentic and has not been tampered with, use the
following command:

- **Production image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest | jq
```

- **Shell image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest-shell | jq
```

- **Dev image**

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest-dev | jq
```

### 📦 **Image SBOMs**

To enhance transparency, we generate SBOMs for each release. SBOMs are available
directly from the container registry and can be verified using using
[Sigstore Cosign](https://www.sigstore.dev/).

#### ✅ Verify the Image Attestations

- **Production image**

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest
```

- **Shell image**

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest-shell
```

- **Dev image**

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/distroless/nginx:latest-dev
```

This will pull in the signature for the attestation specified by the --type
parameter, which in this case is the SPDX attestation. You will receive output
that verifies the SBOM attestation signature in cosign's transparency log:

```shell
Verification for ghcr.io/nlamirault/distroless/nginx:latest --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The code-signing certificate was verified using trusted certificate authority certificates
Certificate subject: https://github.com/nlamirault/distroless/.github/workflows/release.yaml@refs/heads/main
Certificate issuer URL: https://token.actions.githubusercontent.com
GitHub Workflow Trigger: push
GitHub Workflow SHA: ced6b3cfab1341509de55bff7c0389ce81f73aae
GitHub Workflow Name: python
GitHub Workflow Repository: nlamirault/distroless
GitHub Workflow Ref: refs/heads/main
...
```

#### ✅ Download the Image SBOM Attestations

To download an attestation, use the `cosign` download attestation command and
provide both the predicate type and the build platform. For example, the
following command will obtain the SBOM for the python image on `linux/amd64`:

- **Production image**

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/distroless/nginx:latest | jq -r .payload | base64 -d | jq .predicate
```

- **Shell image**

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/distroless/nginx:latest-shell | jq -r .payload | base64 -d | jq .predicate
```

- **Dev image**

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/distroless/nginx:latest-dev | jq -r .payload | base64 -d | jq .predicate
```
