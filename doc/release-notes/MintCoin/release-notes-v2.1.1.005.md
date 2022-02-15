2.1.1.005 Release Notes
===================

Versions used in this release (to be confirmed):
 GCC           4.3.3
 OpenSSL       1.0.1f
 Berkeley DB   5.3.21.NC
 Boost         1.58
 miniupnpc     1.9


Purpose of the release:
=========================


MintCoin version 2.1.1.005 is now available from:

  https://www.mintcoinofficial.eu

Please report bugs using the issue tracker at github:

  https://github.com/EuroCentiem-dev/Mintcoin-Desktop-Wallet/issues

This release is optimized for 64bit operating systems.
This release will only work/compile on 64bit systems using boost 1.71 or higher and OpenSSl 1.1.1 or higher
preparedd for deterministic building

v2.1.1.005 is a maintenance release for the next major release V3.0.0 

Users are encouraged to upgrade to v2.1.3 so that there are supporting nodes for v3.0.0

!! Always take a backup from your wallet.dat before upgrading.

changelog:
==========

* Removed FindMyIP(3th party service) routine, as it causing a segmentation fault
* Removed duplicate time from rpctransaction.cpp which was causing the blockexplorers to fail
* Lowered timeout from 5 seconds to 2.5 seconds as this is more reasonable with current highspeed connections
* Added boost version to daemon startup header as version above 1.67 is mandatory
* Added -Wno-deprecated-copy to makefile.unix to allow the build with newer gcc version
* Added cli argument -nominting to completly disable minting features from the command line
* Added "no minting" behaviour when initial block download is in progress

