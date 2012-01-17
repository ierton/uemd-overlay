# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nodejs/nodejs-0.6.7.ebuild,v 1.1 2012/01/11 07:44:30 patrick Exp $

EAPI="2"

inherit eutils toolchain-funcs

# omgwtf
RESTRICT="test"

DESCRIPTION="Evented IO for V8 Javascript"
HOMEPAGE="http://nodejs.org/"
SRC_URI="http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

DEPEND=">=dev-lang/v8-3.5.10.22
	<dev-lang/v8-3.7
	dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/node-v${PV}

src_configure() {

	if tc-is-cross-compiler ; then

		local ROOT=/usr/$CHOST

		export AR=$(tc-getAR)
		export AS=$(tc-getAS)
		export CC=$(tc-getCC)
		export CPP=$(tc-getCPP)
		export CXX=$(tc-getCXX)
		export LD=$(tc-getLD)
		export NM=$(tc-getNM)
		export PKG_CONFIG=$(tc-getPKG_CONFIG)
		export RANLIB=$(tc-getRANLIB)

		./configure \
			--shared-v8 \
			--shared-v8-includes=$ROOT/usr/include \
			--shared-v8-libpath=$ROOT/usr/lib \
			--prefix=/usr \
			--dest-cpu=${ARCH} \
			--openssl-includes=$ROOT/usr/include \
			--openssl-libpath=$ROOT/usr/lib \
			--without-snapshot || die
	else
		# this is a waf confuserator
		# What about --shared-openssl
		./configure \
			--shared-v8 --prefix=/usr || die
	fi
}

src_compile() {
	emake || die
}

src_install() {
	# FIXME: remove docs from /usr/lib/node_modules
	emake DESTDIR="${D}" install || die
}

src_test() {
	emake test || die
}

