#!/bin/bash
mkdir -p build_root
echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

mkdir -p $LFS/sources

for f in $(cat $DIST_ROOT/build_env/build_env_list)
do
    bn=$(basename $f)

    if ! test -f $LFS/sources/$bn ; then
        wget $f -O $LFS/sources/$bn
    fi
done;

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var,tools}
case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

if ! test $(id -u finabuild) ; then
    groupadd finabuild
    useradd -s /bin/bash -g finabuild -m -k /dev/null finabuild
    passwd finabuild
   
fi
sudo chown -v finabuild $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools,sources}
case $(uname -m) in
   x86_64) sudo chown -v finabuild $LFS/lib64 ;;
esac

fbhome=$(eval echo "~finabuild")

sudo cat > $fbhome/.bashprofile <<EOF
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
   
sudo cat > $fbhome/.bashrc <<EOF
set +hi
umask 022
LFS=$LFS
export DIST_ROOT=$DIST_ROOT
LC_ALL=POSIXal 
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"
EOF