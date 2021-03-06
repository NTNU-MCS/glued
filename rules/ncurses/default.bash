source $pkg_common

configure_common()
{
    dir="$pkg_build_dir/$1"
    $cmd_mkdir "$dir" &&
    cd "$dir" &&
    "../../ncurses-$version/configure" "$2" \
        --prefix="$cfg_dir_toolchain_sysroot/usr" \
        --target="$cfg_target_canonical" \
        --host="$cfg_target_canonical" \
        --build="$cfg_host_canonical" \
	--with-shared \
	--enable-pc-files \
	--without-progs \
	--without-tests \
	--without-profile \
	--without-debug \
        --without-manpages \
        --without-ada \
	--disable-big-core \
	--disable-rpath \
        --disable-nls \
	--enable-echo \
	--enable-const \
	--enable-overwrite \
	--enable-broken_linker &&
        cd -
}

configure()
{
    configure_common normal &&
    configure_common widec --enable-widec
}

build()
{
    $cmd_make -C "$pkg_build_dir/normal" &&
    $cmd_make -C "$pkg_build_dir/widec"
}

host_install()
{
    $cmd_make -C "$pkg_build_dir/normal" install
    $cmd_make -C "$pkg_build_dir/widec" install
}

target_install()
{
    base="$cfg_dir_toolchain_sysroot/usr/lib"

    for lib in curses form menu ncurses panel; do
        for f in "$cfg_dir_toolchain_sysroot/usr/lib/lib$lib"*.so*; do
            if [ -L "$f" ]; then
                cp -av "$f" "$cfg_dir_rootfs/usr/lib"
            else
                $cmd_target_strip -v "$f" -o "$cfg_dir_rootfs/usr/lib/$(basename "$f")"
            fi
        done
    done

    ln -snf /usr/share/terminfo "$cfg_dir_rootfs/usr/lib/terminfo"
    mkdir -p "$cfg_dir_rootfs/usr/share/terminfo/"{v,a,l,x}
    for f in v/{vt100,vt102,vt200,vt220} a/ansi l/linux x/xterm-256color; do
        cp -dpf "$cfg_dir_toolchain_sysroot/usr/share/terminfo/$f" "$cfg_dir_rootfs/usr/share/terminfo/$(dirname $f)"
    done
}
