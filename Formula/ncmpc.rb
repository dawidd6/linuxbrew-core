class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.37.tar.xz"
  sha256 "7c8eb727f6e12d8f97a53915b1b5632898b4afb335a1121c5e01c81df695615c"

  bottle do
    sha256 "d21aef0ebf95c77cdcaa82cc26b9752a3d7882a6c248139654fae3be5261baa5" => :catalina
    sha256 "379fa2e570a4987b05068b6ecb4454c9819da9e9c9670f65a0e158e43ea75afc" => :mojave
    sha256 "e05d6ca991df52846ca07fb2d536cf4644bc225f6a729ae3f180fbb5967356a5" => :high_sierra
    sha256 "09b81dee20fda48322318416c4b6e9b8ca31b405fff26628a0b796ee7e6685f0" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre"
  if OS.mac?
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 800
  else
    fails_with :gcc => "5"
    depends_on "gcc@6" => :build
  end

  fails_with :clang do
    build 800
    cause "error: no matching constructor for initialization of 'value_type'"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dcolors=false", "-Dnls=disabled", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
