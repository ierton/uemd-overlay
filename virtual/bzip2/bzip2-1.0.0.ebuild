# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/qmail/qmail-1.03.ebuild,v 1.10 2011/02/06 12:01:58 leio Exp $

DESCRIPTION="Virtual for bzip2"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc s390 sh sparc x86"

IUSE=""
DEPEND=""

RDEPEND="|| (
	~app-arch/bzip2-1.0.6
	~sys-apps/busybox-1.17.4
)"
