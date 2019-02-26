set -e
pushd .dynamic/privatenet
sudo find . -maxdepth 1 ! -name 'wallet.dat' -type f -exec rm -fv {} +
sudo find . -maxdepth 1 ! -name 'backups' -type d -exec rm -rfv {} +
popd
