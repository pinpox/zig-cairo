# sudo apt-get install -y \
#   libcairo2-dev \
#   libpango1.0-dev \
#   libpangocairo-1.0-0 \
#   xvfb

{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.zig
    pkgs.pango
    pkgs.pango.out
    pkgs.cairo
  ];
}
