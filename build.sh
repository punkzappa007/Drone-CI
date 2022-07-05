abort() { echo "$1"; exit 1; }

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb -b android-11.0"
DT_PATH=device/TECNO/CG8
DT_LINK="https://github.com/punkzappa007/android_device_tecno_TECNO-CG8.git -b PBRP-CG8"

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp11 && cd ~/twrp11

echo " ===+++ Syncing Recovery Sources +++==="
repo init -u https://github.com/PitchBlackRecoveryProject/manifest_pb -b android-11.0
repo sync --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
git clone --depth=1 $DT_LINK device/TECNO/CG8

echo " ===+++ Patching Recovery Sources +++==="
rm -rf bootable/recovery
git clone --depth=1 https://github.com/PitchBlackRecoveryProject/android_bootable_recovery.git -b android-11.0 bootable/recovery
cd bootable/recovery
applyPatch() {
  curl -sL $1 | patch -p1
  [ $? != 0 ] && echo " Patch $1 failed" && exit
}
#applyPatch https://github.com/TeamWin/android_bootable_recovery/commit/878abc76c26e01e98c9b820c143b51086fe1577c.patch
applyPatch https://raw.githubusercontent.com/punkzappa007/android_device_tecno_TECNO-CG8/PBRP-CG8/patch/bootable_recovery-Fix-double-bind-mounting-data-media.patch
cd -

echo " ===+++ Building Recovery +++==="
rm -rf out
source build/envsetup.sh
echo " source build/envsetup.sh done"
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_CG8-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka pbrp || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv recovery.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

curl -T $OUTFILE https://oshi.at
#curl -F "file=@${OUTFILE}" https://file.io
curl --upload-file $OUTFILE http://transfer.sh/
