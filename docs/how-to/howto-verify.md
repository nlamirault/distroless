# How to verify image signatures and provenance

To ensure container images have not been tampered with and were built by the correct CI/CD pipelines, Atoma cryptographically signs its releases and generates build attestations using [Sigstore Cosign](https://www.sigstore.dev/) and GitHub's build provenance system.

Choose the verification method below based on your available tools.

## 1. Verify build provenance using GitHub CLI

The GitHub CLI (`gh`) can check the build provenance, detailing the exact repository, commit, workflow, and runner that generated the image.

Run the following command (substituting `shell` or `infra-tools` and the target tag):

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/atoma/shell:latest
```

---

## 2. Verify signatures using Cosign

All official Atoma images are cryptographically signed during the release pipeline. You can verify the signature validity and the identity of the signer:

```shell
cosign verify \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/atoma/.github/workflows/infra-tools.yaml@refs/heads/main \
  ghcr.io/nlamirault/atoma/infra-tools:latest | jq
```

*Note: Replace the `--certificate-identity` value with the workflow path of the specific image you are verifying (e.g. `shell.yaml` or `release.yaml` depending on the pipeline).*

---

## 3. Verify SBOM attestations

To verify that the SPDX SBOM attestation associated with the image is authentic and signed by our workflow:

```shell
cosign verify-attestation \
  --type=https://spdx.dev/Document \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  --certificate-identity=https://github.com/nlamirault/atoma/.github/workflows/release.yaml@refs/heads/main \
  ghcr.io/nlamirault/atoma/infra-tools:latest
```

---

## 4. Download and inspect SBOM attestations

If you want to pull the verified SBOM directly from the registry for auditing purposes:

```shell
cosign download attestation \
  --platform=linux/amd64 \
  --predicate-type=https://spdx.dev/Document \
  ghcr.io/nlamirault/atoma/infra-tools:latest | jq -r .payload | base64 -d | jq .predicate
```
