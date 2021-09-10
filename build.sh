#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-10.0"
DEVICE=noob
DT_LINK="https://github.com/punkzappa007/android_device_umidigi_a9pro"
DT_PATH=device/umidigi/noob

#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

mkdir -p /tmp/recovery

cd /tmp/recovery

sudo apt install git -y

repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-10.0 -g default,-device,-mips,-darwin,-notdefault 

repo sync -j$(nproc --all)

git clone https://github.com/punkzappa007/android_device_umidigi_a9pro device/umidigi/noob

rm -rf out

. build/envsetup.sh && lunch omni_phoenix-eng && export ALLOW_MISSING_DEPENDENCIES=true && export LC_ALL="C" && mka recoveryimage

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)

cd out/target/product/noob

sudo zip -r9 PBRP-noob.zip recovery.img

curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
