# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Synology drive client installed from deb"
HOMEPAGE=""
SRC_URI="https://global.download.synology.com/download/Utility/SynologyDriveClient/3.1.0-12923/Ubuntu/Installer/x86_64/synology-drive-client-12923.x86_64.deb -> ${P}.deb"

IUSE=""
LICENSE=""
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
	cp -R "${S}/usr" "${D}/usr" || die "Install failed!"
	cp -R "${S}/opt" "${D}/opt" || die "Install failed!"
}
