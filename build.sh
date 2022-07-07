#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1"
DT_LINK="https://github.com/punkzappa007/android_device_tecno_TECNO-CG8.git -b TWRP-CG8"

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp11 && cd ~/twrp11

echo " ===+++ Syncing Recovery Sources  +++==="
#==================working=========
#repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-11.0 --groups=all,-notdefault,-device,-darwin,-x86,-mips
#==================================
repo init --depth=1 -u $MANIFEST
#repo sync -c -j4 --force-sync --no-clone-bundle --no-tags
#repo sync --force-sync
repo sync -j$(nproc --all) -f --force-sync
#repo sync -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j$(nproc --all)

git clone --depth=1 $DT_LINK device/TECNO/CG8
git fetch https://gerrit.twrp.me/android_bootable_recovery refs/changes/05/5405/18 && git cherry-pick FETCH_HEAD
git fetch https://gerrit.twrp.me/android_system_vold refs/changes/40/5540/4 && git cherry-pick FETCH_HEAD

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
export TW_THEME=portrait_hdpi
export ALLOW_MISSING_DEPENDENCIES=true

. build/envsetup.sh
lunch twrp_CG8-userdebug
mka clean
lunch twrp_CG8-userdebug
mka bootimage

#lunch twrp_CG8-eng && mka -j$(nproc --all) pbrp
# Upload zips & recovery.img (U can improvise lateron adding telegram supportetc etc)
echo " ===+++ Uploading Recovery +++==="
cd out/target/product/CG8

sudo zip -r9 PBRP-CG8.zip recovery.img

curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
