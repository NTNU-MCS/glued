version=\
(
    "5.9"
)

url=\
(
    "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-${version}.tar.gz"
)

md5=\
(
    "8cb9c412e5f2d96bc6f459aa8c6282a1"
)

maintainer=\
(
    "Ricardo Martins <rasm@fe.up.pt>"
)

post_unpack()
{
    patches=$(ls "$pkg_dir"/patches/*.patch)

    cd "../$pkg-$version"
    if [ -n "$patches" ]; then
        cat $patches | patch -p1
    fi
}
