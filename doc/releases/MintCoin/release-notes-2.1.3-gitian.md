2.1.3-gitian Release notes
====================


MintCoin version 2.1.3 is now available from:

  https://www.mintcoinofficial.eu

Please report bugs using the issue tracker at github:

  https://github.com/EuroCentiem-dev/Mintcoin-Desktop-Wallet/issues


This release has is only intended for gitian-building and package managment

Code of the wallet has not changed

Optional: Seed the Gitian sources cache and offline git repositories
NOTE: Gitian is sometimes unable to download files. If you have errors, try the step below.

By default, Gitian will fetch source files as needed. To cache them ahead of time, make sure you have checked out the tag you want to build in bitcoin, then:

export USE_DOCKER=0

export USE_LXC=1

export USE_DOCKER=1
export MEM_TO_USE=64000
export PROC_TO_USE=3
export VERSION=2.1.3-gitian
export SIGNER=eurocentiem
export COIN=Mintcoin-Desktop-Wallet
export URL=https://github.com/EuroCentiem-dev/Mintcoin-Desktop-Wallet.git
export COMMIT=2014_03_windows_unicode_path

git clone https://github.com/EuroCentiem-dev/Mintcoin-Desktop-Wallet.git
git clone git://github.com/EuroCentiem-dev/gitian.sigs.git
pushd $COIN
git checkout $VERSION
popd  

cp $COIN/contrib/gitian-build.py ./gitian-build-$COIN-$VERSIO

pushd gitian-builder

add to path if not exists->  PATH=$PATH:$(pwd)/libexec

./bin/make-base-vm --lxc --arch amd64 --suite trusty

mkdir -p inputs
wget -P inputs https://bitcoincore.org/cfields/osslsigncode-Backports-to-1.7.1.patch
wget -P inputs http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz
wget -P inputs https://bitcoincore.org/depends-sources/sdks/MacOSX10.11.sdk.tar.gz


make -C ../Mintcoin-Desktop-Wallet/depends download SOURCES_PATH=`pwd`/cache/common
popd
mkdir -p ../build/v${VERSION}/ -> add $coin#working

./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit $COIN=$VERSION ../$COIN/contrib/gitian-descriptors/gitian-linux.yml


./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit $COIN=${VERSION} ../$COIN/contrib/gitian-descriptors/gitian-linux.yml

./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit dogecoin=v${VERSION} ../dogecoin/contrib/gitian-descriptors/gitian-linux.yml
./bin/gsign --signer $SIGNER --release ${VERSION}-linux --destination ../gitian.sigs ../dogecoin/contrib/gitian-descriptors/gitian-linux.yml
mv build/out/dogecoin-*.tar.gz build/out/src/dogecoin-*.tar.gz ../builds/v${VERSION}/

./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit dogecoin=v${VERSION} ../dogecoin/contrib/gitian-descriptors/gitian-win.yml
./bin/gsign --signer $SIGNER --release ${VERSION}-win --destination ../gitian.sigs ../dogecoin/contrib/gitian-descriptors/gitian-win.yml
mv build/out/dogecoin-*.zip build/out/dogecoin-*.exe ../builds/v${VERSION}/

./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit dogecoin=v${VERSION} ../dogecoin/contrib/gitian-descriptors/gitian-osx.yml
./bin/gsign --signer $SIGNER --release ${VERSION}-osx --destination ../gitian.sigs ../dogecoin/contrib/gitian-descriptors/gitian-osx.yml
mv build/out/dogecoin-*.tar.gz build/out/dogecoin-*.dmg ../builds/v${VERSION}/


export USE_DOCKER=1
export MEM_TO_USE=64000
export PROC_TO_USE=3
export VERSION=2.1.3
-gitian
export SIGNER=eurocentiem
export COIN=Mintcoin-Desktop-Wallet
export URL=https://github.com/EuroCentiem-dev/Mintcoin-Desktop-Wallet.git
./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --commit $COIN=$VERSION ../$COIN/contrib/gitian-descriptors/gitian-linux.yml

BTCPATH=/some/root/path/bitcoin
SIGPATH=/some/root/path/bitcoin-detached-sigs

./bin/gbuild --url bitcoin=${BTCPATH},signature=${SIGPATH} ../bitcoin/contrib/gitian-descriptors/gitian-win-signer.yml


./bin/gbuild -m ${MEM_TO_USE} -j ${PROC_TO_USE} --url --commit $COIN=$URL ../$COIN/contrib/gitian-descriptors/gitian-linux.yml

Offline building

export PATH="$PATH":$(pwd)/gitian-builder/libexec
export URL=$(pwd)/$COIN
export USE_LXC=1
echo $PATH
echo $URL

pushd gitian-builder
./libexec/make-clean-vm --suite trusty --arch amd64

LXC_ARCH=amd64 LXC_SUITE=trusty on-target -u root apt-get update
LXC_ARCH=amd64 LXC_SUITE=trusty on-target -u root \
  -e DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
  $( sed -ne '/^packages:/,/[^-] .*/ {/^- .*/{s/"//g;s/- //;p}}' ../bitcoin/contrib/gitian-descriptors/*|sort|uniq )
LXC_ARCH=amd64 LXC_SUITE=trusty on-target -u root apt-get -q -y purge grub
LXC_ARCH=amd64 LXC_SUITE=trusty on-target -u root -e DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade