# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base flag-o-matic multilib toolchain-funcs

DESCRIPTION="Ratpoints tries to find all rational points on a hyperelliptic curve"
HOMEPAGE="http://www.mathe2.uni-bayreuth.de/stoll/programs/index.html"
SRC_URI="http://www.mathe2.uni-bayreuth.de/stoll/programs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~ppc-macos ~x64-macos"
IUSE="doc sse2"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.1.3-fix-test-program.patch )
if [[ ${CHOST} == *-darwin* ]] ; then
	PATCHES+=( "${FILESDIR}"/${PN}-2.1.3-fix-makefile-macos.patch )
else
	PATCHES+=( "${FILESDIR}"/${PN}-2.1.3-fix-makefile.patch )
fi

pkg_setup() {
	append-cflags -fPIC

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-cflags -fnested-functions
	fi

	if use sse2 ; then
		append-cflags -DUSE_SSE
	fi

	if use doc ; then
		DOCS=( ratpoints-doc.pdf )
	fi

	tc-export CC

	export INSTALL_DIR="${ED}"/usr
	export LIB_DIR=$(get_libdir)
}
