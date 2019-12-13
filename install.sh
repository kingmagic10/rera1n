#!/bin/bash
echo "DEBIAN SYSTEMS ONLY"
echo "FOR OTHER PLATFORMS, SEE README.MD"
echo 
echo "Starting in 10 seconds. Press ctrl-C to cancel."
sleep 10
echo "[*] Package manager supported (apt)"
echo "[*] Creating deps directory"
mkdir rerain-deps
cd rerain-deps
echo "[*] Starting apt... please input root password."
sudo apt-get install -y libusb++ cython libgcrypt20-doc gnutls-doc gnutls-bin usbmuxd git libplist-dev libplist++ python2.7-dev python3-dev libusbmuxd4 libreadline6-dev make libusb-dev openssl libimobiledevice-dev libzip-dev libcurl4-openssl-dev libssl-dev sshpass
echo "[*] Cloning repositories required to run"
git clone https://github.com/lzfse/lzfse
git clone https://github.com/libimobiledevice/libplist
git clone https://github.com/libimobiledevice/libusbmuxd
git clone https://github.com/rcg4u/iphonessh
git clone https://github.com/AidanGamzer/not-secret-secret.git
git clone --recursive https://github.com/libimobiledevice/libimobiledevice
git clone https://github.com/libimobiledevice/libirecovery
git clone https://github.com/libimobiledevice/idevicerestore
git clone https://github.com/tihmstar/libgeneral
git clone https://github.com/tihmstar/img4tool
echo "[*] Installing lzfse"
cd lzfse
make
sudo make install
cd ..
echo
echo "[*] Installing libplist"
cd libplist
sh autogen.sh
make
sudo make install
cd ..
echo
echo "[*] Installing libusbmuxd"
cd libusbmuxd
sh autogen.sh
make
sudo make install
cd ..
echo
echo "[*] Installing USB SSH Deps"
cd iphonessh/python-client
sudo chmod +x *
cd ..
cd ..
sudo cp -R ./iphonessh /usr/bin
echo 
echo "[*] Installing forwarder script for USB SSH"
cd not-secret-secret
sudo chmod +x *
sudo cp -R ./forward.sh /usr/bin
cd ..
echo
echo "[*] Installing libirecovery"
cd libirecovery
./autogen.sh
make
sudo make install
cd ..
echo
echo "[*] Installing idevicerestore"
cd idevicerestore
./autogen.sh
make
sudo make install
cd ..
echo
echo "[*] Installing libgeneral"
cd libgeneral
./autogen.sh
make
sudo make install
cd ..
echo
echo "[*] Installing img4tool"
cd img4tool
./autogen.sh
make
sudo make install
cd ..
echo "[*] Dependencies installed"
sudo ldconfig
echo "[*] You can now start rera1n.sh"

