class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.69.1.tar.bz2"
  sha256 "2ff5e5bd507adf6aa88ff4bbafd4c7af464867ffb688be93b9930717a56c4de8"

  bottle do
    cellar :any
    sha256 "400500fede02f9335bd38c16786b2bbf5e601e358dfac8c21e363d2a8fdd8fac" => :catalina
    sha256 "f082c275f9af1e8e93be12b63a1aff659ba6efa48c8528a97e26c9858a6f95b6" => :mojave
    sha256 "ad023093c252799a4c60646a149bfe14ffa6984817cf463a6f0e98f6551057fe" => :high_sierra
    sha256 "423eeb5fdd77207e6fb9fb214c08d7da2305a8d528319a487c3599a8900f8f6f" => :x86_64_linux
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX} when built with OpenSSL."
    satisfy { OS.mac? || HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" unless OS.mac?

  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-secure-transport
    ]

    if OS.mac?
      args << "--with-darwinssl"
      args << "--without-ca-bundle"
      args << "--without-ca-path"
    else
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"
      args << "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl@1.1/cert.pem"
      args << "--with-ca-path=#{etc}/openssl@1.1/certs"
      args << "--disable-ares"
      args << "--disable-ldap"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
