# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE: this ebuild works only for ARM-based gnueabi embedded systems. Although
# it can be easily modified to support other systems by selecting apropriate
# template from ${S}/mkspecs/qws. See src_repare() for details.
#
# Sergey

inherit eutils toolchain-funcs flag-o-matic

EAPI=3

MY_PN=qt-everywhere-opensource-src
MY_P=${MY_PN}-${PV}

DESCRIPTION="Qt build with framebuffer support"
HOMEPAGE="http://qt.nokia.com/downloads/linux-x11-cpp"
SRC_URI="http://get.qt.nokia.com/qt/source/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 ) "
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

genqmake() { cat << EOF
include(../../common/g++.conf)
include(../../common/linux.conf)
include(../../common/qws.conf)

# modifications to g++.conf
QMAKE_CC                = `tc-getCC`
QMAKE_CXX               = `tc-getCXX`
QMAKE_LINK              = `tc-getCXX`
QMAKE_LINK_SHLIB        = `tc-getCXX`

# modifications to linux.conf
QMAKE_AR                = `tc-getAR` cqs
QMAKE_OBJCOPY           = `tc-getOBJCOPY`
QMAKE_STRIP             = `tc-getSTRIP`

load(qt_config)
EOF
}

src_prepare() {

	# UEMD-board specific patch. Should be removed from other builds.
	epatch "${FILESDIR}"/qt-colorformat.patch

	cp -r mkspecs/qws/linux-arm-gnueabi-g++ mkspecs/qws/linux-local
	genqmake > mkspecs/qws/linux-local/qmake.conf
}

src_configure() {

	export LDFLAGS=""
	export CCFLAGS=""
	export CFLAGS=""
	export CXXFLAGS=""

	./configure \
		-make libs \
		-make tools \
		-make demos \
		\
		-arch arm\
		-embedded \
		-opensource \
		-xplatform qws/linux-local \
		-little-endian \
		-host-little-endian \
		-prefix /opt/qt \
		-prefix-install \
		-qt-gfx-linuxfb \
		-confirm-license \
		\
		-no-qt3support \
		-no-multimedia \
		-no-audio-backend \
		-no-phonon \
		-no-cups \
		-no-gtkstyle \
		-no-nas-sound \
		-no-sm \
		-no-xshape \
		-no-xvideo \
		-no-xsync \
		-no-xinerama \
		-no-xcursor \
		-no-xfixes \
		-no-xrandr \
		-no-xrender \
		-no-mitshm \
		-fontconfig \
		-xinput \
		-no-xkb

}

src_compile() {
	make
}

src_install() {
	export INSTALL_ROOT="${D}"
	make install
}

