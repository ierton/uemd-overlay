# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/v8/Attic/v8-3.5.10.24.ebuild,v 1.4 2011/12/17 21:52:50 floppym dead $

EAPI="3"

inherit eutils flag-o-matic multilib pax-utils scons-utils toolchain-funcs

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="http://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 ~arm x86 ~x64-macos ~x86-macos"
IUSE="readline"

RDEPEND="readline? ( >=sys-libs/readline-6.1 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	tc-export AR CC CXX RANLIB

	# Make the build respect LDFLAGS.
	export LINKFLAGS="${LDFLAGS}"
}

src_prepare() {
	# Stop -Werror from breaking the build.
	epatch "${FILESDIR}"/${PN}-no-werror-r0.patch

	# Respect the user's CFLAGS, including the optimization level.
	epatch "${FILESDIR}"/${PN}-no-O3-r0.patch
}

src_configure() {
	# GCC issues multiple warnings about strict-aliasing issues in v8 code.
	append-flags -fno-strict-aliasing
}

src_compile() {
	local myconf="library=shared soname=on importenv=LINKFLAGS,PATH"

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*)
			myconf+=" arch=ia32"
			;;
		x86_64-*)
			if [[ $ABI = "" ]] ; then
				myconf+=" arch=x64"
			else
				myarch="$ABI"
			fi
			;;
		arm*-*)
			myconf+=" arch=arm "
			# FIXME: Illegal instruction bug workaround
			myconf+=" armeabi=soft"
			;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac

	if tc-is-cross-compiler ; then
		myconf+=" snapshot=off"
	fi

	escons $(use_scons readline console readline dumb) ${myconf} || die
}

src_install() {
	insinto /usr
	doins -r include || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8-${PV}$(get_libname) \
			libv8-${PV}$(get_libname) || die
	fi

	dolib libv8-${PV}$(get_libname) || die
	dosym libv8-${PV}$(get_libname) /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}
