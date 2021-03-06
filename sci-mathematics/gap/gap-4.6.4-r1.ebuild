# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib autotools-utils elisp-common

MY_P="gap-lite-${PV}"

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="mirror://sagemath/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="+gmp emacs vim-syntax readline"

RESTRICT="mirror"

DEPEND="gmp? ( dev-libs/gmp )
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.7-cflags.patch
	"${FILESDIR}"/${PN}-4.5.7-writeandcheck.patch
	"${FILESDIR}"/${PN}-4.5.7-testall.patch
	"${FILESDIR}"/${PN}-4.6.4-Makefile.patch
	)

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare(){
	sed -i "s:gapdir=\`pwd\`:gapdir=${EPREFIX}/usr/$(get_libdir)/${PN}:" \
		configure.in

	autotools-utils_src_prepare
}

src_configure(){
	local myeconfargs=(
		$(use_with readline)
		ABI=""
		)

	if (use gmp); then
		myeconfargs+=(--with-gmp=system)
	else
		myeconfargs+=(--with-gmp=no)
	fi

	autotools-utils_src_configure
	emake config
}

src_install(){
	insinto /usr/$(get_libdir)/${PN}
	doins -r *

	newbin bin/gap.sh gap

	dosym /usr/$(get_libdir)/${PN}/sysinfo.gap /etc/sysinfo.gap

	source sysinfo.gap

	local MUST_BE_EXECUTABLE_FOR_LATER_COMPILING=(
		config.status
		configure
		gap.shi
		makepkgs
		cnf/config.guess
		cnf/config.sub
		cnf/configure.out
		cnf/install-sh
		etc/install-tools.sh
		tst/remake.sh
		)
	for i in ${MUST_BE_EXECUTABLE_FOR_LATER_COMPILING}; do
		fperms 755 /usr/$(get_libdir)/${PN}/$i
	done
	# Make the real gap program executable again after install
	einfo "making /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap executable"
	fperms 755 /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
