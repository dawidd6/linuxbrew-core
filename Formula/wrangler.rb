class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  revision 1
  head "https://github.com/RefactoringTools/wrangler.git"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.2.tar.gz"
    sha256 "a6a87ad0513b95bf208c660d112b77ae1951266b7b4b60d8a2a6da7159310b87"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888f.patch?full_index=1"
      sha256 "b7911206315c32ee08fc89776015cf5b26c97b6cb4f6eff0b73dcf2d583cfe31"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "129a7cacfe094491f22d885546ac36dcdd60c601f391b290970fadbc5777ca22" => :catalina
    sha256 "6ca8b450fc9c98d43c9e6494bd725d2785ed70f010193237bb34c13f54be7303" => :mojave
    sha256 "7708561c89c92c61b67907ca43fa351e9a39da572c43e1f9d15d4dc0cd4855da" => :high_sierra
    sha256 "c5b90dd316ebf81b24f0379ffc289139d9dbb8838a4be4fac5555ffc576798a6" => :x86_64_linux
  end

  depends_on "erlang@20"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert_predicate Pathname.new(suffixtree), :executable?, "suffixtree must be executable"
  end
end
