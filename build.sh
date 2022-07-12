#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb -b android-10.0"
DT_LINK="https://github.com/punkzappa007/android_device_umidigi_a9pro.git -b android-10.0"

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp11 && cd ~/twrp11

echo " ===+++ Syncing Recovery Sources  +++==="
#==================working=========
#repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-11.0 --groups=all,-notdefault,-device,-darwin,-x86,-mips
#==================================
repo init -u https://github.com/PitchBlackRecoveryProject/manifest_pb -b android-11.0
repo sync --force-sync --no-clone-bundle --no-tags -j$(nproc --all)

#repo init --depth=1 -u $MANIFEST
#repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone --depth=1 $DT_LINK device/UMIDIGI/A9_Pro

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
export TW_THEME=portrait_hdpi
export ALLOW_MISSING_DEPENDENCIES=true
#lunch omni_cg8-eng && mka pbrp
lunch twrp_A9_Pro-eng && mka -j$(nproc --all) pbrp
# Upload zips & recovery.img (U can improvise lateron adding telegram supportetc etc) 
echo " ===+++ Uploading Recovery +++==="
cd out/target/product/A9_Pro

sudo zip -r9 PBRP-A9_Pro.zip recovery.img

curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
