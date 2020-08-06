.PHONY: build clean help

build: ## Build the PDF document (default).
	mkdir -p .cache/Tectonic
	docker run -ti --rm -v $(CURDIR)/src:/mnt -v $(CURDIR)/.cache/Tectonic:/root/.cache/Tectonic -w /mnt vinay0410/tectonic-image sh -c "tectonic cpu-bitness.tex && chown -R $(shell id -u):$(shell id -g) cpu-bitness.pdf /root/.cache/Tectonic"

clean: ## Removes the running container.
	rm -rf src/cpu-bitness.pdf .cache

help: ## Displays these usage instructions.
	@echo "Usage: make <target(s)>"
	@echo
	@echo "Specify one or multiple of the following targets and they will be processed in the given order:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-16s%s\n", $$1, $$2}' $(MAKEFILE_LIST)

