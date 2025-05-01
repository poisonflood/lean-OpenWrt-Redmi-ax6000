#!/bin/bash
set -ex

# Configuration
export REPO_URL="https://github.com/coolsnowwolf/lede.git"
export REPO_BRANCH="master"
export TZ="Europe/Paris"
#export WORK_DIR="$HOME/openwrt-build"
export WORK_DIR="$HOME/git/kernels/lean-OpenWrt-Redmi-ax6000"
export OPENWRT_DIR="$WORK_DIR/openwrt"
export OUTPUT_DIR="$WORK_DIR/output"

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#debian
[[ `uname -n` == "ubuntu" ]] && {
sudo apt update
sudo apt install build-essential clang flex bison g++ gawk \
    gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
    python3-setuptools rsync swig unzip zlib1g-dev file wget
}

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#gentoo
[[ `uname -n` == "gentoo" ]] && {
sudo emerge --sync --quiet
sudo emerge -avuDN app-arch/{bzip2,sharutils,unzip,zip} sys-process/time \
                   app-text/asciidoc \
                   dev-libs/{libusb-compat,libxslt,openssl} dev-util/intltool \
                   dev-vcs/{git,mercurial} net-misc/{rsync,wget} \
                   sys-apps/util-linux sys-devel/{bc,bin86,dev86} \
                   sys-libs/{ncurses,zlib} virtual/perl-ExtUtils-MakeMaker
}

# Setup build environment
if [ ! -d "$WORK_DIR" ]; then
    git clone https://github.com/poisonflood/lean-OpenWrt-Redmi-ax6000 "$WORK_DIR"
fi
cd "$WORK_DIR"

# Clone source code
if [ ! -d "$OPENWRT_DIR" ]; then
    git clone "$REPO_URL" -b "$REPO_BRANCH" "$OPENWRT_DIR"
fi

# Apply custom configurations
cd "$OPENWRT_DIR"
[ -f "$WORK_DIR/feeds.conf.default" ] && cp "$WORK_DIR/feeds.conf.default" .
[ -f "$WORK_DIR/diy-part1.sh" ] && {
    chmod +x "$WORK_DIR/diy-part1.sh"
    "$WORK_DIR/diy-part1.sh"
}

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Apply secondary configuration
[ -f "$WORK_DIR/.config" ] && cp "$WORK_DIR/.config" .
[ -f "$WORK_DIR/diy-part2.sh" ] && {
    chmod +x "$WORK_DIR/diy-part2.sh"
    "$WORK_DIR/diy-part2.sh"
}

# Download packages
make defconfig
make download -j$(nproc)
find dl -size -1024c -delete

# Compile firmware
echo "Starting compilation with $(nproc) threads"
make -j$(nproc) || make -j1 || make -j1 V=s

# Organize output
mkdir -p "$OUTPUT_DIR"
cp -r bin/targets/*/* "$OUTPUT_DIR"
rm -rf "$OUTPUT_DIR"/packages

echo "Build completed! Output files are in: $OUTPUT_DIR"

