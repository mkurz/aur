# Maintainer: Lukas Spiss <lukas.spiss@outlook.de>

pkgname=mockoon-bin
pkgver=9.6.1
pkgrel=1
pkgdesc="Mockoon is the easiest and quickest way to run mock APIs locally."
arch=('x86_64' 'aarch64')
url="https://mockoon.com/"
license=('MIT')
groups=('base-devel')
depends=()
source_x86_64=("https://github.com/mockoon/mockoon/releases/download/v9.6.1/mockoon-${pkgver}.amd64.deb")
source_aarch64=("https://github.com/mockoon/mockoon/releases/download/v9.6.1/mockoon-${pkgver}.arm64.deb")
sha256sums_x86_64=('5bb599cb5fe5b9bbd024b3105e1d747343389990c5a956e69103a67166c2d98d')
sha256sums_aarch64=('9379d954d8eb2862600ff4f4c4fd4dbaf9fcc6afdea3cc8c69ff2880c502a813')

package() {
	install -dm755 "${pkgdir}"/usr/bin/
	cd "$srcdir/"
	tar -xf data.tar.xz -C "${pkgdir}"

	ln -s /opt/Mockoon/mockoon "${pkgdir}"/usr/bin/mockoon
}
