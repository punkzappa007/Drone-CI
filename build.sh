#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-11.0"
DEVICE=CG8
DT_LINK="https://github.com/punkzappa007/android_device_tecno_CG8-PBRP"
DT_PATH=device/tecno/CG8

echo " ===+++ Setting up Build Environment +++==="
sudo -E apt-get -y purge azure-cli ghc* zulu* hhvm llvm* firefox google* dotnet* powershell openjdk* mysql* php* 
sudo -E apt-get clean 
sudo -E apt-get -qq update
sudo -E apt-get -qq install bc build-essential zip curl libstdc++6 git wget python gcc clang libssl-dev repo rsync flex curl  bison aria2
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo

echo " ===+++ Syncing Recovery Sources +++==="
mkdir work
cd work
repo init -u $MANIFEST --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips
repo sync -j4
git clone $DT_LINK --depth=1 --single-branch $DT_PATH

echo " ===+++ Building Recovery +++==="
cd work
. build/envsetup.sh
export TW_THEME=portrait_hdpi
export ALLOW_MISSING_DEPENDENCIES=true
lunch omni_${DEVICE}-eng && mka bootimage

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv boot.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

#curl -T $OUTFILE https://oshi.at
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
