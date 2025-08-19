# SPDX-FileCopyrightText: Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
# SPDX-License-Identifier: Apache-2.0

include hack/commons.mk

SCRIPTS_DIR="."

ARCH := $(shell uname -m)

# ====================================
# D E V E L O P M E N T
# ====================================

##@ Development

.PHONY: clean
clean: ## Cleanup
	@echo -e "$(OK_COLOR)[$(BANNER)] Cleanup$(NO_COLOR)"
	@find . -name "*-amd64" | xargs rm -f
	@find . -name "*-arm64" | xargs rm -f
	@find . -name "melange.rsa*" | xargs rm -f
	@find . -name "packages" | xargs rm -fr
	@rm -f sbom-*.cdx sbom-*.json
	@rm -f portefaix-distroless.tar

.PHONY: check
check: check-docker ## Check requirements

# ====================================
# C H A I N G U A R D
# ====================================

##@ Chainguard

.PHONY: build
build: guard-IMAGE ## Build the APK using Docker images
	@echo -e "$(OK_COLOR)[$(APP)] Build the Container image$(NO_COLOR) $(ARCH)"
	pushd $(IMAGE) \
	  && test -f melange.rsa || docker run --rm -it --privileged -v "${PWD}/$(IMAGE):/work" -w /work cgr.dev/chainguard/melange:latest keygen \
    && docker run --privileged --rm -v "${PWD}/$(IMAGE):/work" -w /work cgr.dev/chainguard/melange:latest build melange.yaml --arch "$(ARCH)" --signing-key melange.rsa \
    && popd
