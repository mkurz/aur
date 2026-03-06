# Maintainer: Ash <xash at riseup d0t net>

pkgname=async-profiler-bin
_pkgname=async-profiler
pkgver=4.2.1
pkgrel=1
pkgdesc='Sampling CPU and HEAP profiler for Java featuring AsyncGetCallTrace + perf_events (prebuilt binaries)'
arch=('x86_64' 'aarch64')
url='https://github.com/async-profiler/async-profiler'
license=('Apache')
depends=('java-environment')
provides=('async-profiler')
conflicts=('async-profiler')
options=('!strip')

source_x86_64=("https://github.com/${_pkgname}/${_pkgname}/releases/download/v${pkgver}/async-profiler-${pkgver}-linux-x64.tar.gz")
source_aarch64=("https://github.com/${_pkgname}/${_pkgname}/releases/download/v${pkgver}/async-profiler-${pkgver}-linux-arm64.tar.gz")
sha256sums_x86_64=('e4d764f27d06a1d339d13df4f2e1599558b69fcfb01d4c811d13b8c895d7ea63')
sha256sums_aarch64=('b7f58eead5973d5b04a920380f278e75cf190b49435974c3569869d298639664')

package() {
    _arch="x64"
    if [[ $CARCH == "aarch64" ]]; then
        _arch="arm64"
    fi
    cd "${_pkgname}-${pkgver}-linux-${_arch}"

    # upstream layout
    install -d "${pkgdir}/opt/async-profiler"
    cp -a --no-preserve=ownership . "${pkgdir}/opt/async-profiler/"

    # binaries
    install -d "${pkgdir}/usr/bin"
    ln -sf /opt/async-profiler/bin/asprof "${pkgdir}/usr/bin/asprof"
    ln -sf /opt/async-profiler/bin/jfrconv "${pkgdir}/usr/bin/jfrconv"

    # shared library
    install -d "${pkgdir}/usr/lib"
    ln -sf /opt/async-profiler/lib/libasyncProfiler.so \
        "${pkgdir}/usr/lib/libasyncProfiler.so"

    # headers
    install -d "${pkgdir}/usr/include"
    ln -sf /opt/async-profiler/include/asprof.h \
        "${pkgdir}/usr/include/asprof.h"

    install -Dm644 LICENSE \
        "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
