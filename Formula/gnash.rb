class Gnash < Formula
  desc "Modular C++ reimplementation of GNU Bash 5.3 with shell personalities"
  homepage "https://github.com/brianjfox/gnash"
  url "https://github.com/brianjfox/gnash/archive/refs/tags/gnash-1.7.1.tar.gz"
  sha256 "25986f2b44e7740f553d327d7dd79dfb5f33c3d25c50af9a614345bf0745147c"
  license "GPL-2.0-only" # GPLv2 with the GPLv2-AI Exception; see the repository
  head "https://github.com/brianjfox/gnash.git", branch: "main"

  # Prebuilt binaries.  `brew install gnash' uses these when one exists for the
  # host; otherwise it falls back to building from source.  Bottles are attached
  # to the matching release in this tap's repo.
  bottle do
    root_url "https://github.com/brianjfox/homebrew-tools/releases/download/gnash-1.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "73df6041fa59aa82327c165c5e87271c4f74fd63de382aab06f806867e448219"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DGNASH_WERROR=OFF", "-DGNASH_BUILD_TESTS=OFF", *std_cmake_args
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
