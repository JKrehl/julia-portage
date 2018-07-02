# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Simulation software to model electromagnetic systems"
HOMEPAGE="http://ab-initio.mit.edu/meep/"
SRC_URI="https://github.com/stevengj/meep/releases/download/v${PV}.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples hdf5 mpi"

RDEPEND="
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	sci-physics/harminv
	>=sci-libs/libctl-4
	hdf5? ( sci-libs/hdf5:= )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2-pc-no-ldflags.patch
	#"${FILESDIR}"/${PN}-1.2-no-auto-mpb.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with mpi) \
		$(use_with hdf5)
}

src_test() {
	# pml test buggy with optimization on
	# http://thread.gmane.org/gmane.comp.science.electromagnetism.meep.general/4579
	emake -C tests pml CXXFLAGS="-O0"
	emake check
}

src_install() {
	default

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
