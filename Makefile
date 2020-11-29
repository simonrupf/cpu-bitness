.PHONY: build clean help

build: src/cpu-bitness.pdf ## Build the PDF document (default).

src/cpu-bitness.pdf: src/cpu-bitness.tex src/.cache/Tectonic
	docker run -ti --rm -v $(CURDIR)/src:/mnt -e HOME=/mnt -w /mnt -u $(shell id -u):$(shell id -g) vinay0410/tectonic-image tectonic cpu-bitness.tex

src/.cache/Tectonic:
	mkdir -p src/.cache/Tectonic

ref: ref/Intel\ Chips\ timeline.pdf ref/Intel\ 8085.pdf ## Create screen optimized PDFs of original reference material

ref/Intel\ Chips\ timeline.pdf: ref/originals/Intel\ Chips\ timeline.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$@" "$<"

ref/Intel\ 8085.pdf: ref/originals/Intel\ 8085.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$@" "$<"

clean: ## Removes the generated PDF and Tectonic cache.
	rm -rf src/cpu-bitness.pdf .cache

help: ## Displays these usage instructions.
	@echo "Usage: make <target(s)>"
	@echo
	@echo "Specify one or multiple of the following targets and they will be processed in the given order:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-16s%s\n", $$1, $$2}' $(MAKEFILE_LIST)

