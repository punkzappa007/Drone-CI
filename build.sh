#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-10.0"
DEVICE=CG8
DT_LINK="https://github.com/punkzappa007/android_device_tecno_TECNO-CG8.git -b CG8-PBRP"
DT_PATH=device/tecno/CG8

echo " ===+++ Setting up Build Environment +++==="
#apt install openssh-server openjdk-8-jdk -y
apt install openssh-server -y
apt update --fix-missing
#apt install openssh-server openjdk-8-jdk -y
apt install openssh-server -y
mkdir ~/twrpBuilding && cd ~/twrpBuilding

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST -g default,-device,-mips,-darwin,-notdefault 
repo sync -j$(nproc --all)
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
rm -rf out
source build/envsetup.sh
echo " source build/envsetup.sh done"
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch twrp_${DEVICE}-eng done"
mka bootimage || abort " mka failed with exit status $?"
echo " mka bootimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv recovery.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

#curl -T $OUTFILE https://oshi.at
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
