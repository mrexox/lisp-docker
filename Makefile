SBCL  = 2.0.11
CLISP = 2.49

SBCL_VERSION  = $(SBCL)-r0
CLISP_VERSION = $(CLISP)-r3

build: sbcl clisp

sbcl:
	docker build \
	--build-arg "SBCL_VERSION=$(SBCL_VERSION)" \
	--file sbcl.dockerfile \
	--tag mrexox/sbcl:$(SBCL) \
	--tag mrexox/sbcl:$(SBCL)-alpine \
	.

clisp:
	docker build \
	--build-arg "CLISP_VERSION=$(CLISP_VERSION)" \
	--file clisp.dockerfile \
	--tag mrexox/clisp:$(CLISP) \
	--tag mrexox/clisp:$(CLISP)-alpine \
	.
