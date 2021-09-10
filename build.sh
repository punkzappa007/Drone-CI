#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-10.0"
DEVICE=noob
DT_LINK="https://github.com/punkzappa007/android_device_umidigi_a9pro"
DT_PATH=device/umidigi/noob

echo " ===+++ Setting up Build Environment +++==="
sudo -E apt-get -y purge azure-cli ghc* zulu* hhvm llvm* firefox google* dotnet* powershell openjdk* mysql* php* 
sudo -E apt-get clean 
sudo -E apt-get -qq update
sudo -E apt-get -qq install bc build-essential zip curl libstdc++6 git wget python gcc clang libssl-dev repo rsync flex curl  bison aria2
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo
mkdir work
cd work

echo " ===+++ Syncing Recovery Sources +++==="
repo init -u $MANIFEST --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips
repo sync -j4
git clone $DT_LINK --depth=1 --single-branch $DT_PATH

echo " ===+++ Building Recovery +++==="
cd work
. build/envsetup.sh &&lunch omni_$DEVICE-eng &&export ALLOW_MISSING_DEPENDENCIES=true && mka $TARGET
