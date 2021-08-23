CPU bitness
===========

The latest version of this document in PDF format can be found in the
[releases](https://github.com/simonrupf/cpu-bitness/releases/latest).

References
----------
When possible, the referenced documents are included in the `ref` folder. Some
of the source PDFs found online are very large and have been committed to source
control only in lower, "screen" resolution formats and/or with the page ranges
extracted that are refered to in the document. This extraction process can be
found in the `Makefile`.

Build
-----
To build the document or resize the reference files, use `make`.

The following tools are needed:
- GNU make
- Docker (or Podman with `alias docker=podman` set)
- GhostScript is only needed for resizing the reference PDFs in the `ref` folder
