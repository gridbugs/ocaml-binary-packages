#!/bin/sh
set -eu


TAG=$1
TARGET=$2
OUTPUT=$3

OCAML_VERSION=5.2.0
OCAML_LSP_SERVER_VERSION=1.19.0

TMP_DIR="$(mktemp -d -t ocaml-binary-packages-build.XXXXXXXXXX)"
echo "$TMP_DIR"
#trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"
opam switch create . "ocaml.$OCAML_VERSION"
eval "$(opam env)"
opam install -y "ocaml-lsp-server.$OCAML_LSP_SERVER_VERSION"

ARCHIVE_NAME="ocaml-lsp-server.$OCAML_LSP_SERVER_VERSION+binary-ocaml-$OCAML_VERSION-built-$TAG-$TARGET"

mkdir -p "$ARCHIVE_NAME"
cp _opam/bin/ocamllsp "$ARCHIVE_NAME"
tar --format=posix -cvf "$ARCHIVE_NAME.tar" "$ARCHIVE_NAME"
gzip -9 "$ARCHIVE_NAME.tar"
mv "$ARCHIVE_NAME.tar.gz" $OUTPUT
