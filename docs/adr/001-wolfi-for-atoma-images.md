---
adr: 001
status: ✅ Accepted
date: 2025-01-09
deciders: Nicolas Lamirault
consulted:
informed: Development team
spdx-license: Apache-2.0
---

# ADR-001: Atoma Container Images

## Context

We need to build secure, minimal container images for various infrastructure
tools and applications. Traditional Linux distributions like Ubuntu, Debian, or
Alpine come with significant overhead and potential security vulnerabilities due
to their general-purpose nature. The goal is to create "distroless" images that
contain only the necessary components to run applications, reducing attack
surface and image size.

Key requirements:

- Minimal attack surface with no unnecessary packages
- Regular security updates and vulnerability management
- Supply chain security with signed packages
- Multi-architecture support (amd64, arm64)
- Compatibility with modern container tooling
- Reproducible builds

## Considered Options

1. **Wolfi Linux** - Purpose-built distribution for containers
2. **Alpine Linux** - Minimal Linux distribution with musl libc
3. **Google Distroless** - Pre-built distroless base images
4. **Ubuntu/Debian minimal** - Stripped-down versions of traditional
   distributions

## Pros and Cons

### 1. Wolfi Linux

**Pros:**

- ✅ Built specifically for containers and cloud-native workloads
- ✅ Rolling release model with latest security patches
- ✅ All packages are signed and have SBOMs (Software Bill of Materials)
- ✅ Uses glibc for better application compatibility
- ✅ Designed with supply chain security in mind
- ✅ Integrates seamlessly with Chainguard tooling (melange, apko)
- ✅ Minimal package set reduces attack surface
- ✅ Multi-architecture support built-in
- ✅ Reproducible builds with declarative configuration

**Cons:**

- 🚫 Newer distribution with smaller ecosystem
- 🚫 Dependency on Chainguard's infrastructure
- 🚫 Learning curve for team unfamiliar with Wolfi

### 2. Alpine Linux

**Pros:**

- ✅ Very small base image size
- ✅ Mature ecosystem with extensive package repository
- ✅ Well-known in container community
- ✅ Security-focused with regular updates

**Cons:**

- 🚫 Uses musl libc which can cause compatibility issues
- 🚫 Package signing not as comprehensive
- 🚫 General-purpose distribution with unnecessary components
- 🚫 Manual SBOM generation required

### 3. Google Distroless

**Pros:**

- ✅ Pre-built and maintained by Google
- ✅ Very minimal with no shell or package manager
- ✅ Regular security updates

**Cons:**

- 🚫 Limited customization options
- 🚫 Dependency on Google's release schedule
- 🚫 No control over package selection
- 🚫 Limited language runtime support

### 4. Ubuntu/Debian Minimal

**Pros:**

- ✅ Familiar to most developers
- ✅ Extensive package repositories
- ✅ Long-term support options

**Cons:**

- 🚫 Still contains many unnecessary packages
- 🚫 Larger image sizes
- 🚫 General-purpose design not optimized for containers
- 🚫 Complex dependency management

## Decision

We will use **Wolfi Linux** as the base distribution for our distroless
container images.

The decision is driven by Wolfi's purpose-built design for container workloads,
superior supply chain security features, and seamless integration with modern
container building tools. The signed packages with SBOMs provide the
transparency and security assurance required for production deployments.

## Consequences

**Positive:**

- Enhanced security posture with signed packages and comprehensive SBOMs
- Smaller attack surface compared to general-purpose distributions
- Better supply chain visibility and vulnerability management
- Reproducible builds with declarative configuration
- Seamless integration with Chainguard's security tooling ecosystem
- Regular security updates without waiting for LTS cycles

**Negative:**

- Team needs to learn Wolfi-specific package management and tooling
- Dependency on Chainguard's package repository and infrastructure
- Potential compatibility issues with applications expecting specific system
  libraries
- Smaller community compared to established distributions like Alpine

**Mitigation Strategies:**

- Provide team training on Wolfi and Chainguard tooling
- Maintain fallback options for critical applications if compatibility issues
  arise
- Monitor Chainguard's roadmap and community growth
- Document any Wolfi-specific configurations and workarounds
