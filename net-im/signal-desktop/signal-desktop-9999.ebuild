# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit git-r3

DESCRIPTION="Signal Private Messenger for the Desktop"
HOMEPAGE="https://whispersystems.org"

EGIT_REPO_URI="https://github.com/WhisperSystems/Signal-Desktop"
EGIT_BRANCH="development"
DEPEND="dev-vcs/git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE=""

DEPEND="
	sys-apps/yarn
	net-libs/nodejs
"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}" || die
	yarn install
}

src_compile() {
	cd "${S}" || die
	yarn run pack-prod
}

src_install() {
	local install_dir="/usr/lib/signal"

	cd "${S}" || die

	dodir "${install_dir}"
	cp -R ./dist/linux-unpacked/* "${D}/${install_dir}" || die "Install failed!"

	insinto /usr/share/applications/
	doins "${FILESDIR}/signal.desktop"

	for i in 1024 512 256 128 64; do
		local tdir="/usr/share/icons/hicolor/${i}x${i}/apps"
		dodir $tdir
		insinto $tdir
		newins ./build/icons/png/${i}x${i}.png signal.png
	done

	dosym "${install_dir}/signal-desktop" "/usr/bin/signal-desktop"
}
