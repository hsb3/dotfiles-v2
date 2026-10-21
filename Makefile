# Makefile: `make check` is the gate; `make fmt` rewrites scripts with shfmt.
.PHONY: check fmt

check:
	@_gate/check.sh

fmt:
	@_gate/check.sh fmt
