# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs versionator

MY_P="${PN}-$(replace_version_separator 2 '.')"

DESCRIPTION="Conductor and Reduction Types for Genus 2 Curves"
HOMEPAGE="http://www.math.u-bordeaux.fr/~liu/G2R/"
SRC_URI="http://cage.ugent.be/~jdemeyer/sage/${MY_P}.spkg -> ${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND="sci-mathematics/pari:3"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	epatch "${FILESDIR}"/${MY_P}.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o ${PN} ${PN}.c -lpari24 -lgmp -lm \
		|| die "compilation of source failed"
}

src_install() {
	dobin ${PN} || die "installation failed!"
	dodoc README RELEASE.NOTES WARNING || die
}