.PHONY: build clean help

build: src/cpu-bitness.pdf ## Build the PDF document (default).

src/cpu-bitness.pdf: src/cpu-bitness.tex src/.cache/Tectonic
	docker run -ti --rm -v $(CURDIR)/src:/mnt -e HOME=/mnt -w /mnt -u $(shell id -u):$(shell id -g) vinay0410/tectonic-image tectonic cpu-bitness.tex

src/.cache/Tectonic:
	mkdir -p src/.cache/Tectonic

ref: ref/Hitachi\ HD64180\ Hardware\ Manual\ 4th\ Edition.pdf ref/Intel\ Chips\ timeline.pdf ref/Intel\ 8085.pdf ## Create screen optimized PDFs of original reference material

ref/Hitachi\ HD64180\ Hardware\ Manual\ 4th\ Edition.pdf: ref/originals/HD64180Z\ Hardware\ Manual\ 4th\ Edition.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -dFirstPage=2 -dLastPage=2 -sOutputFile=/tmp/HD64180-1.pdf "$<"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -dFirstPage=18 -dLastPage=18 -sOutputFile=/tmp/HD64180-2.pdf "$<"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -dFirstPage=51 -dLastPage=57 -sOutputFile=/tmp/HD64180-3.pdf "$<"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -dFirstPage=173 -dLastPage=182 -sOutputFile=/tmp/HD64180-4.pdf "$<"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -dFirstPage=220 -dLastPage=220 -sOutputFile=/tmp/HD64180-5.pdf "$<"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$@" /tmp/HD64180-?.pdf
	rm /tmp/HD64180-?.pdf

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

