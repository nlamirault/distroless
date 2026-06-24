# Shell

Container image with Bash and tooling including `curl`, `netcat`, `jq`, `yq`.

## Versions

| 📌 Version | ⬇️ Pull URL                                     |
| ---------- | ---------------------------------------------- |
| latest     | ghcr.io/nlamirault/atoma/shell:latest     |
| latest-dev | ghcr.io/nlamirault/atoma/shell:latest-dev |

## ✅ Verify the Provenance

GitHub CLI ([gh](https://cli.github.com/)) can be used to retrieve the build
provenance, which details the exact commit, workflow, and runner that produced
the image:

- **Production image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/atoma/shell:latest
```

- **Shell image**

```shell
gh attestation verify \
  --owner nlamirault \
  oci://ghcr.io/nlamirault/atoma/shell:latest-shell
```
