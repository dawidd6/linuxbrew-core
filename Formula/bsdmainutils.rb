class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_11.1.2.tar.gz"
  sha256 "101c0dede5f599921533da08a46b53a60936445e54aa5df1b31608f1407fee60"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d97c44ab6e2decc460d0950e77a3ff5ea6edff38a55aa4b8a5d8182d997461f" => :x86_64_linux
  end

  depends_on :linux
  unless OS.mac?
    depends_on "ncurses"
    depends_on "libbsd"
  end

  def install
    File.open("debian/patches/series") do |file|
      file.each { |patch| system "patch -p1 <debian/patches/#{patch}" }
    end
    inreplace "Makefile", "/usr/", "#{prefix}/"
    inreplace "config.mk", "/usr/", "#{prefix}/"
    inreplace "config.mk", " -o root -g root", ""
    inreplace "usr.bin/write/Makefile", "chown root:tty $(bindir)/$(PROG)", ""
    system "make", "install"
  end

  test do
    system "#{bin}/cal"
  end
end
