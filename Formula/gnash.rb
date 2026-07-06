class Gnash < Formula
  desc "Modular C++ reimplementation of GNU Bash 5.3 with shell personalities"
  homepage "https://github.com/brianjfox/gnash"
  url "https://github.com/brianjfox/gnash/archive/refs/tags/gnash-1.3.1.tar.gz"
  sha256 "bfc80dc379a2b1c11283e902df91554a694fee63cc8951171365e574a045acd9"
  license "GPL-2.0-only" # GPLv2 with the GPLv2-AI Exception; see the repository
  head "https://github.com/brianjfox/gnash.git", branch: "main"

  # Prebuilt binaries.  `brew install gnash' uses these when one exists for the
  # host; otherwise it falls back to building from source.  Bottles are attached
  # to the matching release in this tap's repo.
  bottle do
    root_url "https://github.com/brianjfox/homebrew-tools/releases/download/gnash-1.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "df6c594eea58da4d6cdd693b80dc500a85e3eeba3dd16af4dc0fdc1cd08e4f5b"
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
