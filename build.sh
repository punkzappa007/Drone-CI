#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD

MANIFEST="https://gitlab.com/OrangeFox/sync.git"
DEVICE=A9_Pro
DT_LINK="https://github.com/punkzappa007/android_device_umidigi_a9pro.git -b android-10.0"
DT_PATH=device/UMIDIGI/A9_Pro

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir mkdir ~/OrangeFox_sync && cd ~/OrangeFox_sync

echo " ===+++ Syncing Recovery Sources  +++==="
git clone $MANIFEST
cd ~/OrangeFox_sync/sync/
./orangefox_sync.sh --branch 10.0 --path ~/fox_10.0
cd ~/fox_10.0
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
cd ~/fox_10.0
. build/envsetup.sh
export TW_THEME=portrait_hdpi
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_A9_Pro-eng && mka bootimage

# Upload zips & recovery.img (U can improvise lateron adding telegram supportetc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd ~/fox_11.0/out/target/product/$DEVICE
mv boot.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

#curl -T $OUTFILE https://oshi.at
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
