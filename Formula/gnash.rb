class Gnash < Formula
  desc "Modular C++ reimplementation of GNU Bash 5.3 with shell personalities"
  homepage "https://github.com/brianjfox/gnash"
  url "https://github.com/brianjfox/gnash/archive/refs/tags/gnash-2.2.3.tar.gz"
  sha256 "8a16955c6169c8d4213fbe6be17590a6c67b8d9083d8cb9be224eea9d331f9d2"
  license "GPL-2.0-only" # GPLv2 with the GPLv2-AI Exception; see the repository
  head "https://github.com/brianjfox/gnash.git", branch: "main"

  # Prebuilt binaries.  `brew install gnash' uses these when one exists for the
  # host; otherwise it falls back to building from source.  Bottles are attached
  # to the matching release in this tap's repo.
  bottle do
    root_url "https://github.com/brianjfox/homebrew-tools/releases/download/gnash-2.2.3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44d976d34b2379033414459ed1ee04bd6f779a88665b64e8eaf2dd85763bee99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "44d976d34b2379033414459ed1ee04bd6f779a88665b64e8eaf2dd85763bee99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d976d34b2379033414459ed1ee04bd6f779a88665b64e8eaf2dd85763bee99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "44d976d34b2379033414459ed1ee04bd6f779a88665b64e8eaf2dd85763bee99"
  end

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
