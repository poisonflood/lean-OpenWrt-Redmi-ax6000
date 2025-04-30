#!/bin/bash
set -ex

# Configuration
export REPO_URL="https://github.com/coolsnowwolf/lede.git"
export REPO_BRANCH="master"
export TZ="Europe/Paris"
export WORK_DIR="$HOME/openwrt-build"
export OPENWRT_DIR="$WORK_DIR/openwrt"
export OUTPUT_DIR="$WORK_DIR/output"

# Initialize environment
sudo timedatectl set-timezone "$TZ"
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe multiverse
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y \
    build-essential rsync asciidoc binutils bzip2 gawk gettext git libncurses5-dev \
    patch python3 unzip zlib1g-dev lib32gcc-s1 subversion flex uglifyjs gcc-multilib \
    p7zip p7zip-full msmtp libssl-dev texinfo libreadline-dev libglib2.0-dev xmlto \
    qemu-utils upx-ucl libelf-dev autoconf automake libtool device-tree-compiler \
    g++-multilib antlr3 gperf wget ccache curl swig coreutils vim nano python3-pip \
    haveged lrzsz scons libpython3-dev zstd dwarves llvm clang lldb lld aria2 libbpf-dev

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

