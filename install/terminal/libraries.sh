#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y \
      build-essential pkg-config autoconf bison clang rustc pipx \
      libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
      libvips imagemagick libmagickwand-dev mupdf mupdf-tools \
      redis-tools sqlite3 libsqlite3-0 default-libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common
}

omak_install() {
    sudo apt-get install -y \
      build-essential pkg-config autoconf bison clang rustc pipx \
      libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
      libvips imagemagick libmagickwand-dev mupdf mupdf-tools \
      redis-tools sqlite3 libsqlite3-0 default-libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
