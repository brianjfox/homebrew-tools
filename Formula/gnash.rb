class Gnash < Formula
  desc "Modular C++ reimplementation of GNU Bash 5.3 with shell personalities"
  homepage "https://github.com/brianjfox/gnash"
  url "https://github.com/brianjfox/gnash/archive/refs/tags/gnash-1.3.8.tar.gz"
  sha256 "7e26ae2b30f214df6ed08f02f0cc52d632e4fdcb0613367873f2e129829a79c2"
  license "GPL-2.0-only" # GPLv2 with the GPLv2-AI Exception; see the repository
  head "https://github.com/brianjfox/gnash.git", branch: "main"

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
