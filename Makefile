# standard arguments used in all ghostscript commands
PDF_ARGS=-sDEVICE=pdfwrite\
         -dPDFA=1\
         -sPDFACompatibilityPolicy=1\
         -sColorConversionStrategy=RGB\
         -sProcessColorModel=DeviceRGB\
         -dNOPAUSE\
         -dQUIET\
         -dBATCH

# these will be optimized for "screen"
PDFS=ref/Intel\ Chips\ timeline.pdf\
     ref/Intel\ 4004.pdf\
     ref/Intel\ 8085.pdf\
     ref/MOS\ 6510.pdf

# these need special treatment
SPECIAL_PDFS=ref/Hitachi\ HD64180\ Hardware\ Manual\ 4th\ Edition.pdf\
             ref/MOS\ MCS6500.pdf

.PHONY: build clean help pdfs

build: src/cpu-bitness.pdf ## Build the PDF document (default).

src/cpu-bitness.pdf: src/cpu-bitness.tex src/.cache/Tectonic
	docker run -ti --rm -v $(CURDIR)/src:/mnt -e HOME=/mnt -w /mnt -u $(shell id -u):$(shell id -g) vinay0410/tectonic-image tectonic cpu-bitness.tex

src/.cache/Tectonic:
	mkdir -p src/.cache/Tectonic

ref: pdfs ## Create screen optimized PDFs of original reference material

pdfs: $(PDFS) $(SPECIAL_PDFS)

ref/Hitachi\ HD64180\ Hardware\ Manual\ 4th\ Edition.pdf: ref/originals/HD64180Z\ Hardware\ Manual\ 4th\ Edition.pdf
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -dFirstPage=2   -dLastPage=2   -sOutputFile=/tmp/HD64180-1.pdf "$<"
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -dFirstPage=18  -dLastPage=18  -sOutputFile=/tmp/HD64180-2.pdf "$<"
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -dFirstPage=51  -dLastPage=57  -sOutputFile=/tmp/HD64180-3.pdf "$<"
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -dFirstPage=173 -dLastPage=182 -sOutputFile=/tmp/HD64180-4.pdf "$<"
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -dFirstPage=220 -dLastPage=220 -sOutputFile=/tmp/HD64180-5.pdf "$<"
	gs $(PDF_ARGS) -sOutputFile="$@" /tmp/HD64180-?.pdf
	rm /tmp/HD64180-?.pdf

ref/Intel\ Chips\ timeline.pdf: ref/originals/Intel\ Chips\ timeline.pdf
ref/Intel\ 4004.pdf: ref/originals/Intel\ 4004.pdf
ref/Intel\ 8085.pdf: ref/originals/Intel\ 8085.pdf
ref/MOS\ 6510.pdf: ref/originals/MOS\ 6510.pdf

# doesn't contain OCR information and illegible with "screen" optimization
ref/MOS\ MCS6500.pdf: ref/originals/MOS\ MCS6500.pdf
	gs $(PDF_ARGS) -dPDFSETTINGS=/ebook -sOutputFile="$@" "$<"

$(PDFS):
	gs $(PDF_ARGS) -dPDFSETTINGS=/screen -sOutputFile="$@" "$<"

clean: ## Removes the generated PDF and Tectonic cache.
	rm -rf src/cpu-bitness.pdf .cache

help: ## Displays these usage instructions.
	@echo "Usage: make <target(s)>"
	@echo
	@echo "Specify one or multiple of the following targets and they will be processed in the given order:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-16s%s\n", $$1, $$2}' $(MAKEFILE_LIST)

