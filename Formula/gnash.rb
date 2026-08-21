class Gnash < Formula
  desc "Modular C++ reimplementation of GNU Bash 5.3 with shell personalities"
  homepage "https://github.com/brianjfox/gnash"
  url "https://github.com/brianjfox/gnash/archive/refs/tags/gnash-2.2.1.tar.gz"
  sha256 "72f7bb0848ca0f038012f6a71b8dffd24abb9383d6317de9ab57e35c1574f16f"
  license "GPL-2.0-only" # GPLv2 with the GPLv2-AI Exception; see the repository
  head "https://github.com/brianjfox/gnash.git", branch: "main"

  depends_on "cmake" => :build

  def install
    # Build for macOS 13+ so the (any_skip_relocation) bottle runs on every
    # supported macOS, not only the version it was bottled on.  Superenv pins
    # MACOSX_DEPLOYMENT_TARGET to the host, so both must be overridden.
    args = []
    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "13.0"
      args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0"
    end
    system "cmake", "-S", ".", "-B", "build",
           "-DGNASH_WERROR=OFF", "-DGNASH_BUILD_TESTS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/core/gnash"
  end

  test do
    # Behaves as bash 5.3 by default.
    assert_match "5.3", shell_output("#{bin}/gnash -c 'echo $BASH_VERSION'")
    assert_equal "42", shell_output("#{bin}/gnash -c 'echo $((6 * 7))'").strip
    # And can take on the csh personality.
    assert_equal "b",
      shell_output("#{bin}/gnash --personality=csh -c 'set l = (a b c); echo $l[2]'").strip
  end
end
