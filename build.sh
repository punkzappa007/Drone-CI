#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb -b android-10.0"
DT_LINK="https://github.com/punkzappa007/android_device_tecno_TECNO-CG8.git -b PBRP-CG8"

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp11 && cd ~/twrp11

echo " ===+++ Syncing Recovery Sources  +++==="
repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-11.0 --groups=all,-notdefault,-device,-darwin,-x86,-mips
repo sync --force-sync --no-clone-bundle --no-tags -j$(nproc --all)

#repo init --depth=1 -u $MANIFEST
#repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone --depth=1 $DT_LINK device/tecno/CG8

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
export TW_THEME=portrait_hdpi
export ALLOW_MISSING_DEPENDENCIES=true
#lunch omni_cg8-eng && mka pbrp
lunch omni_CG8-eng && mka -j$(nproc --all) pbrp
# Upload zips & recovery.img (U can improvise lateron adding telegram supportetc etc) 
echo " ===+++ Uploading Recovery +++==="
cd out/target/product/CG8

sudo zip -r9 PBRP-CG8.zip recovery.img

curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
