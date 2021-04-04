FROM alpine:3 AS builder

RUN apk add --no-cache clisp gnupg

WORKDIR /tmp

RUN wget -O quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp && \
    wget -O quicklisp.lisp.asc https://beta.quicklisp.org/quicklisp.lisp.asc && \
    wget -O release-key.txt https://beta.quicklisp.org/release-key.txt

RUN gpg --import release-key.txt && gpg --verify quicklisp.lisp.asc quicklisp.lisp

COPY installer.lisp installer.lisp

RUN clisp installer.lisp

FROM alpine:3

ARG CLISP_VERSION=2.49-r3

RUN apk add --no-cache clisp=${CLISP_VERSION}

# Do not run containers as root !
# See: https://sysdig.com/blog/dockerfile-best-practices/
# Copy these files to your user's directory

COPY --from=builder /root/quicklisp/ /root/quicklisp
COPY --from=builder /root/.clisprc.lisp /root/.clisprc.lisp

ENV LISP=clisp
