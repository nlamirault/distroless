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

# .PHONY: build-apk
# build-apk: guard-IMAGE ## Build the APK using Docker images (only if melange.yaml exists)
# 	@echo -e "$(OK_COLOR)[$(APP)] Build APK packages: $(ARCH)$(NO_COLOR)"
# 	@if [ -f "$(IMAGE)/melange.yaml" ]; then \
# 		test -f ${PWD}/keys/melange.rsa || docker run --privileged --rm -it --privileged -v "${PWD}:/work" -w /work/$(IMAGE) cgr.dev/chainguard/melange:latest keygen; \
# 		docker run --privileged --rm -v "${PWD}:/work" -w /work/$(IMAGE) cgr.dev/chainguard/melange:latest build melange.yaml --arch "$(ARCH)" --signing-key ../../melange.rsa; \
# 	else \
# 		echo -e "$(INFO_COLOR)[$(APP)] No melange.yaml found in $(IMAGE), skipping APK build$(NO_COLOR)"; \
# 	fi

.PHONY: build-apk
build-apk: guard-IMAGE ## Build the APK using Docker images (only if melange.yaml exists)
	@echo -e "$(OK_COLOR)[$(APP)] Build APK packages: $(ARCH)$(NO_COLOR)"
	@if [ -f "$(IMAGE)/melange.yaml" ]; then \
		test -f ${PWD}/keys/melange.rsa || docker run --rm -v "${PWD}/keys":/work cgr.dev/chainguard/melange keygen; \
		docker run --privileged --rm -v "${PWD}":/work cgr.dev/chainguard/melange build $(IMAGE)/melange.yaml --arch "$(ARCH)" --signing-key /work/keys/melange.rsa; \
	else \
		echo -e "$(INFO_COLOR)[$(APP)] No melange.yaml found in $(IMAGE), skipping APK build$(NO_COLOR)"; \
	fi

.PHONY: build-image
build-image: guard-IMAGE ## Build container image with apko
	@echo -e "$(OK_COLOR)[$(APP)] Build container image: $(ARCH)$(NO_COLOR)"
	@if [ -f "$(IMAGE)/melange.yaml" ]; then \
		$(MAKE) build-apk IMAGE=$(IMAGE); \
	fi
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	# docker run --rm -v "${PWD}:/work" -w /work busybox:latest ls /work/melange.rsa.pub
	docker run --rm -v "${PWD}:/work" -w /work cgr.dev/chainguard/apko:latest build $(IMAGE)/prod.yaml $(IMAGE_NAME):latest $(IMAGE)/$(IMAGE_NAME).tar --arch $(ARCH)

.PHONY: build-dev-image
build-dev-image: guard-IMAGE ## Build development container image with apko
	@echo -e "$(OK_COLOR)[$(APP)] Build development container image: $(ARCH)$(NO_COLOR)"
	@if [ -f "$(IMAGE)/melange.yaml" ]; then \
		$(MAKE) build-apk IMAGE=$(IMAGE); \
	fi
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	@if [ -f "$(IMAGE)/dev.yaml" ]; then \
		docker run --rm -v "${PWD}:/work" -w /work cgr.dev/chainguard/apko:latest build $(IMAGE)/dev.yaml $(IMAGE_NAME):dev $(IMAGE)/$(IMAGE_NAME)-dev.tar --arch $(ARCH); \
	else \
		echo -e "$(INFO_COLOR)[$(APP)] No dev.yaml found in $(IMAGE), skipping dev image build$(NO_COLOR)"; \
	fi

.PHONY: build-shell-image
build-shell-image: guard-IMAGE ## Build shell container image with apko
	@echo -e "$(OK_COLOR)[$(APP)] Build shell container image: $(ARCH)$(NO_COLOR)"
	@if [ -f "$(IMAGE)/melange.yaml" ]; then \
		$(MAKE) build-apk IMAGE=$(IMAGE); \
	fi
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	@if [ -f "$(IMAGE)/shell.yaml" ]; then \
		docker run --rm -v "${PWD}:/work" -w /work cgr.dev/chainguard/apko:latest build $(IMAGE)/shell.yaml $(IMAGE_NAME):shell $(IMAGE)/$(IMAGE_NAME)-shell.tar --arch $(ARCH); \
	else \
		echo -e "$(INFO_COLOR)[$(APP)] No shell.yaml found in $(IMAGE), skipping shell image build$(NO_COLOR)"; \
	fi

.PHONY: build-all
build-all: guard-IMAGE ## Build APK packages and all container images
	@echo -e "$(OK_COLOR)[$(APP)] Build all images for $(IMAGE)$(NO_COLOR)"
	$(MAKE) build-image IMAGE=$(IMAGE)
	$(MAKE) build-dev-image IMAGE=$(IMAGE)
	$(MAKE) build-shell-image IMAGE=$(IMAGE)

# ====================================
# I M A G E S
# ====================================

##@ Images

.PHONY: infra-tools
infra-tools: ## Build infra-tools image
	$(MAKE) build-all IMAGE=images/infra-tools

.PHONY: shell
shell: ## Build shell image
	$(MAKE) build-all IMAGE=images/shell

.PHONY: nginx
nginx: ## Build nginx image
	$(MAKE) build-all IMAGE=images/nginx

.PHONY: all-images
all-images: ## Build all images
	$(MAKE) infra-tools
	$(MAKE) shell
	$(MAKE) nginx

# ====================================
# T E S T I N G
# ====================================

##@ Testing

.PHONY: test
test: guard-IMAGE ## Test container image
	@echo -e "$(OK_COLOR)[$(APP)] Test container image$(NO_COLOR)"
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	@if [ -f "$(IMAGE)/$(IMAGE_NAME).tar" ]; then \
		docker load < $(IMAGE)/$(IMAGE_NAME).tar; \
		docker run --rm $(IMAGE_NAME):latest --version || true; \
	else \
		echo -e "$(ERROR_COLOR)Image tar file not found. Run 'make build-image IMAGE=$(IMAGE)' first$(NO_COLOR)"; \
	fi

.PHONY: test-infra-tools
test-infra-tools: ## Test infra-tools image
	$(MAKE) test IMAGE=images/infra-tools

# ====================================
# S E C U R I T Y
# ====================================

##@ Security

.PHONY: scan
scan: guard-IMAGE ## Scan container image for vulnerabilities
	@echo -e "$(OK_COLOR)[$(APP)] Scan container image$(NO_COLOR)"
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	@if [ -f "$(IMAGE)/$(IMAGE_NAME).tar" ]; then \
		docker load < $(IMAGE)/$(IMAGE_NAME).tar; \
		grype $(IMAGE_NAME):latest; \
	else \
		echo -e "$(ERROR_COLOR)Image tar file not found. Run 'make build-image IMAGE=$(IMAGE)' first$(NO_COLOR)"; \
	fi

.PHONY: sbom
sbom: guard-IMAGE ## Generate SBOM for container image
	@echo -e "$(OK_COLOR)[$(APP)] Generate SBOM$(NO_COLOR)"
	$(eval IMAGE_NAME := $(shell basename $(IMAGE)))
	@if [ -f "$(IMAGE)/$(IMAGE_NAME).tar" ]; then \
		docker load < $(IMAGE)/$(IMAGE_NAME).tar; \
		syft $(IMAGE_NAME):latest -o spdx-json=sbom-$(IMAGE_NAME).json; \
		syft $(IMAGE_NAME):latest -o cyclonedx-json=sbom-$(IMAGE_NAME).cdx; \
	else \
		echo -e "$(ERROR_COLOR)Image tar file not found. Run 'make build-image IMAGE=$(IMAGE)' first$(NO_COLOR)"; \
	fi

# ====================================
# F O R M A T T I N G
# ====================================

##@ Formatting

.PHONY: fmt
fmt: ## Format code
	@echo -e "$(OK_COLOR)[$(APP)] Format code$(NO_COLOR)"
	dprint fmt

.PHONY: lint
lint: ## Lint code
	@echo -e "$(OK_COLOR)[$(APP)] Lint code$(NO_COLOR)"
	dprint check

# ====================================
# G I T   H O O K S
# ====================================

##@ Git Hooks

.PHONY: pre-commit
pre-commit: ## Run pre-commit hooks
	@echo -e "$(OK_COLOR)[$(APP)] Run pre-commit hooks$(NO_COLOR)"
	pre-commit run --all-files

.PHONY: install-hooks
install-hooks: ## Install pre-commit hooks
	@echo -e "$(OK_COLOR)[$(APP)] Install pre-commit hooks$(NO_COLOR)"
	pre-commit install
