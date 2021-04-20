# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DXFRW_COMMIT="0b7b7b709d9299565db603f878214656ef5e9ddf"
DXFRW_PV="0.6.3"
DXFRW_P="libdxfrw-${DXFRW_PV}-${DXFRW_COMMIT}"

MIMALLOC_COMMIT="dc6bce256d4f3ce87761f9337977dff3d8b1776c"
MIMALLOC_PV="2.0.1"
MIMALLOC_P="mimalloc-${MIMALLOC_PV}-${MIMALLOC_COMMIT}"

inherit cmake-utils gnome2-utils

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="http://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/solvespace/libdxfrw/archive/${DXFRW_COMMIT}.tar.gz -> ${DXFRW_P}.tar.gz
	https://github.com/microsoft/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz -> ${MIMALLOC_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

BDEPEND="
	openmp? ( >=sys-devel/gcc-4.2 )
"
RDEPEND="
	x11-libs/cairo
	sys-libs/zlib
	dev-cpp/gtkmm:2.4=
	dev-cpp/pangomm:1.4
	dev-libs/json-c:=
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/libpng:0=
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# NOTE: please keep commit hash actually when version up
GIT_COMMIT_HASH="0e0b0252e23dd5bd4ae82ababcc54c44aee036d6"

src_prepare() {
	rm -rf "extlib/libdxfrw" || die  "rm extlib/libdxfrw failed"
	mv "${WORKDIR}/libdxfrw-${DXFRW_COMMIT}" "extlib/libdxfrw" || die "move libdxfrw-${DXFRW_COMMIT} failed"
	rm -rf "extlib/mimalloc" || die  "rm extlib/mimalloc failed"
	mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "extlib/mimalloc" || die "move mimalloc-${MIMALLOC_COMMIT} failed"
	sed -i '/include(GetGitCommitHash)/d' CMakeLists.txt || die 'remove GetGitCommitHash by sed failed'
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}"
	)
	if use openmp ; then
		mycmakeargs+=("-DENABLE_OPENMP=ON")
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
