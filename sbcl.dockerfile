FROM alpine:3 AS builder

RUN apk add --no-cache sbcl gnupg

WORKDIR /tmp

RUN wget -O quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp && \
    wget -O quicklisp.lisp.asc https://beta.quicklisp.org/quicklisp.lisp.asc && \
    wget -O release-key.txt https://beta.quicklisp.org/release-key.txt

RUN gpg --import release-key.txt && gpg --verify quicklisp.lisp.asc quicklisp.lisp

COPY installer.lisp installer.lisp

RUN sbcl --script installer.lisp

FROM alpine:3

ARG SBCL_VERSION=2.0.11-r0

RUN apk add --no-cache sbcl=${SBCL_VERSION}

# Do not run containers as root !
# See: https://sysdig.com/blog/dockerfile-best-practices/
# Copy these files to your user's directory

COPY --from=builder /root/quicklisp/ /root/quicklisp
COPY --from=builder /root/.sbclrc /root/.sbclrc

ENV LISP=sbcl
