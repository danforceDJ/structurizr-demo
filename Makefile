# Detect container runtime (prefer podman if available, fallback to docker)
SHELL := /bin/bash
CONTAINER_RUNTIME := $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)
PROJECT_ROOT := $(or $(shell git rev-parse --show-toplevel 2>/dev/null),$(CURDIR))
DOMAINS := $(sort $(notdir $(wildcard arch-repository/*-domain-*)))
DOMAIN ?=

define CHOOSE_DOMAIN
domain="$(DOMAIN)"; \
if [ -z "$$domain" ]; then \
	echo "Available domains:"; \
	i=1; \
	for d in $(DOMAINS); do \
		echo "  $$i) $$d"; \
		i=$$((i+1)); \
	done; \
	printf "Choose domain number or name: "; \
	read -r answer; \
	if [[ "$$answer" =~ ^[0-9]+$$ ]]; then \
		domain="$$(echo "$(DOMAINS)" | awk -v idx="$$answer" '{print $$idx}')"; \
	else \
		domain="$$answer"; \
	fi; \
fi; \
if ! echo " $(DOMAINS) " | grep -Fq " $$domain "; then \
	echo "Unknown domain: $$domain"; \
	echo "Valid choices: $(DOMAINS)"; \
	exit 1; \
fi
endef


.PHONY: help run validate run-% validate-% combine run-combined staticsite test-container setup-server
help:
	@echo "Available commands:"
	@echo "  make run					         - Run Structurizr Local for a domain"
	@echo "  make validate [DOMAIN=<folder>]     - Validate one domain workspace"
	@echo "Available domain folders: $(DOMAINS)"

run:
	$(CONTAINER_RUNTIME) run -it --rm \
		-p 8080:8080 \
		-v "$(PROJECT_ROOT)":/usr/local/structurizr \
		-e STRUCTURIZR_WORKSPACES=* \
		--name structurizr_local \
		structurizr/structurizr local

validate:
	@$(CHOOSE_DOMAIN); \
	echo "Validating Structurizr workspace..."; \
	$(CONTAINER_RUNTIME) run -it --rm \
		-v "$(PROJECT_ROOT)":/usr/local/structurizr \
		structurizr/structurizr validate \
		--workspace /usr/local/structurizr/arch-repository/$$domain/workspace.dsl
