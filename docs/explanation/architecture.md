# Architecture and design

This section explains the design principles behind the Atoma image ecosystem and the reasoning behind choosing **Wolfi**, **apko**, and **melange**.

---

## 1. What is a "Distroless" container image?

Standard container base images (like Ubuntu, Debian, or Alpine) packages a full Linux operating system, including package managers, shells, utility commands, and extensive system libraries. While convenient, this comes with major security and operational tradeoffs:

1. **Large attack surface**: Extraneous packages can contain critical vulnerabilities (CVEs) that are exposed inside your container network.
2. **Larger image size**: Unused packages waste disk space, network bandwidth, and memory.

**Distroless** container images solve this by containing *only* your application and its direct runtime dependencies (such as libc, ca-certificates, and libraries). They exclude shells, package managers, and other standard OS tools.

---

## 2. Why Wolfi OS?

[Wolfi](https://wolfi.dev/) is an open-source Linux distribution specifically designed for modern cloud-native workloads, container security, and securing the software supply chain:

- **Security-first**: Package updates are quickly compiled and released to resolve CVEs promptly.
- **Glibc compatibility**: Unlike Alpine (which uses `musl` libc), Wolfi uses `glibc` (GNU C Library). This ensures compatibility with most compiled programs and languages (Go, Node.js, Python, Java) without compilation errors.
- **Granular packages**: Packages are split into minimal units, making it easy to include only what is needed.

---

## 3. The tooling: Apko & Melange

To build Wolfi-based distroless images, Atoma uses two companion tools designed by Chainguard:

### Melange: Package building
`melange` builds APK packages from source inside a clean, reproducible, and secure environment. It outputs standard `.apk` packages that can be signed and distributed. We use `melange` to compile dependencies (like `jsonnet-bundler` in `infra-tools`) that are not present in upstream repositories.

### Apko: Image assembly
`apko` acts as the assembler. Unlike a `Dockerfile` which executes imperative commands (like `apt install` or `apk add` inside a running layer), `apko` builds the container image filesystem *declaratively*:
- It reads a YAML list of APK package dependencies.
- It pulls them, unpacks their contents directly into a directory structure, and produces an OCI image layer.
- It generates reproducible builds (building the exact same configuration yields the identical cryptographic image digest).
- It generates rich metadata (SBOMs, signatures) directly during the build step.

---

## 4. Defaulting to Non-Root

Running containers as root is a high-risk practice. If an attacker escapes a root-run container, they may gain administrator rights on the host node.

Atoma images enforce non-root security by default:
- An unprivileged user `nonroot` (UID `65532`, GID `65532`) is created.
- The `apko` configuration sets `run-as: nonroot` as the default execution identity.
- The default working directory is set to `/home/nonroot`.

---

## 5. Software Supply Chain Security

Securing the supply chain means verifying who built the image and ensuring that its contents have not been modified. Atoma addresses this through:

1. **Cryptographic signatures**: All releases are signed via Sigstore Cosign.
2. **Build provenance**: Build workflows generate SLSA (Supply-chain Levels for Software Artifacts) provenance attestations.
3. **Software Bill of Materials (SBOM)**: Every image contains a verified record of its component packages, allowing instant auditing.
