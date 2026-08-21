# Maintainer: Caleb Maclennan <caleb@alerque.com>
# Contributor: Gabriel Saillard (GitSquared) <gabriel@saillard.dev>
# Contributor: David Birks <david@tellus.space>
# Contributor: Simon Doppler (dopsi) <dop.simon@gmail.com>
# Contributor: dpeukert

pkgname=marktext
_upstream_ver=0.20.0-rc.1
pkgver=${_upstream_ver/-rc./rc}
pkgrel=1
pkgdesc='A simple and elegant open-source markdown editor that focused on speed and usability'
arch=(x86_64 aarch64)
url=https://www.marktext.cc
_url="https://github.com/$pkgname/$pkgname"
license=(MIT)
_electron=electron42
depends=("$_electron"
         libxkbfile
         libsecret
         openssl
         ripgrep)
makedepends=(nodejs
             pnpm
             python)
_archive="$pkgname-$_upstream_ver"
source=("$_archive.tar.gz::$_url/archive/refs/tags/v$_upstream_ver.tar.gz"
        "$pkgname.sh"
        "$pkgname-arg-handling.patch")
sha256sums=('6495adc035ba9fd8ef4f992605cc16b2f15f52d5d7a1c6095fe2c6d9694ab192'
            '5214b3326020467879aab65d5138591a578e4e69bc46b4427964641ffbd9c8ca'
            '7ee21967b63976a582bc585ad8680573494fd14070885161540badb8f6e16ecc')

prepare() {
	cd "$_archive"
	patch -Np1 -i "$srcdir/$pkgname-arg-handling.patch"
	grep -q '^pmOnFail:' pnpm-workspace.yaml ||
		sed -i '1i pmOnFail: ignore' pnpm-workspace.yaml
	grep -q '^overrides:' pnpm-workspace.yaml ||
		sed -i '1i shamefullyHoist: true\noverrides:\n  postcss: 8.5.15\n  esbuild@>=0.27.0 <0.28.1: 0.28.1' \
			pnpm-workspace.yaml

	# A shared Electron derives resourcesPath from its own installation rather
	# than from this application. Let the launcher point MarkText at its own
	# extra resources without changing bundled-Electron behavior upstream.
	sed -i \
		's/process\.resourcesPath/(process.env.MARKTEXT_RESOURCES_PATH || process.resourcesPath)/g' \
		packages/desktop/src/common/filesystem/paths.ts \
		packages/desktop/src/common/i18n.ts \
		packages/desktop/src/main/globalSetting.ts \
		packages/desktop/src/main/ipc/bootInfo.ts \
		packages/desktop/src/main/menu/templates/help.ts

	# Upstream's postinstall downloads its own bundled Electron. Install the
	# dependencies without lifecycle scripts and rebuild only the native modules
	# against the selected Arch system Electron instead.
	CI=true pnpm install --frozen-lockfile --ignore-scripts \
		--store-dir "$srcdir/pnpm-store"
	(
		cd packages/desktop
		./node_modules/.bin/patch-package
		./node_modules/.bin/electron-rebuild \
			-f -v "$(<"/usr/lib/$_electron/version")"
	)
	./node_modules/.bin/tsx scripts/minify-locales.ts
}

build() {
	local _electron_arch
	case "$CARCH" in
		x86_64) _electron_arch=x64 ;;
		aarch64) _electron_arch=arm64 ;;
		*) error "Unsupported architecture: $CARCH"; return 1 ;;
	esac

	cd "$_archive"
	(
		cd packages/desktop
		./node_modules/.bin/electron-vite build
		npm_config_user_agent=pnpm ./node_modules/.bin/electron-builder \
			--linux "--$_electron_arch" --dir \
			--config.electronDist="/usr/lib/$_electron" \
			--config.electronVersion="$(<"/usr/lib/$_electron/version")"
	)
	sed -e "s/@ELECTRON@/$_electron/" "../$pkgname.sh" > "$pkgname"
}

package() {
	local _unpacked _rg_package
	case "$CARCH" in
		x86_64)
			_unpacked=linux-unpacked
			_rg_package=ripgrep-linux-x64
			;;
		aarch64)
			_unpacked=linux-arm64-unpacked
			_rg_package=ripgrep-linux-arm64
			;;
		*) error "Unsupported architecture: $CARCH"; return 1 ;;
	esac

	cd "$_archive"
	install -Dm0755 -t "$pkgdir/usr/bin/" "$pkgname"
	install -d "$pkgdir/usr/lib/$pkgname"
	cp -a "dist/$_unpacked/resources/." "$pkgdir/usr/lib/$pkgname/"

	local _rg_path="$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/@vscode/$_rg_package/bin"
	ln -sf /usr/bin/rg "$_rg_path/rg"

	local _desktop=packages/desktop
	install -Dm0644 -t "$pkgdir/usr/share/applications/" \
		"$_desktop/build/linux/$pkgname.desktop"
	install -Dm0644 -t "$pkgdir/usr/share/metainfo/" \
		"$_desktop/build/linux/$pkgname.appdata.xml"
	install -Dm0644 "$_desktop/build/icons/512x512/$pkgname.png" \
		"$pkgdir/usr/share/pixmaps/$pkgname.png"
	local _size
	for _size in 16 24 32 48 64 128 256 512; do
		install -Dm0644 "$_desktop/build/icons/${_size}x${_size}/$pkgname.png" \
			"$pkgdir/usr/share/icons/hicolor/${_size}x${_size}/apps/$pkgname.png"
	done

	install -Dm0644 -t "$pkgdir/usr/share/licenses/$pkgname/" LICENSE
	install -Dm0644 -t "$pkgdir/usr/share/doc/$pkgname/" \
		README.md .github/CONTRIBUTING.md
	cp -a docs "$pkgdir/usr/share/doc/$pkgname/"
}
