echo "Inside GCC pass 1"
echo
sleep 1

cd $LFS/sources
tar -xf gcc-12.2.0.tar.xz
cd gcc-12.2.0

tar -xf ../mpfr-4.2.1.tar.xz
mv -pv mpfr-4.2.1 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -pv gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -pv mpc-1.3.1 mpc



case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -pv build
cd       build

../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.39 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make && make install

cd $LFS/sources
rm -rf gcc-12.2.0
echo
echo "[ OK ] GCC Pass 1 complete"