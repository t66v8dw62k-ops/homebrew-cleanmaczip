class Cleanmaczip < Formula
  desc "Create clean zip archives on macOS without Finder artefacts"
  homepage "https://github.com/t66v8dw62k-ops/homebrew-cleanmaczip"
  url "https://github.com/t66v8dw62k-ops/homebrew-cleanmaczip/archive/refs/tags/v1.tar.gz"
  sha256 "a555a950c1bd2a7af4512a3312221f2682316c55b94a2ea5931b7f22704f5f91"
  license "MIT"

  depends_on :macos

  def install
    bin.install "main.sh" => "cleanmaczip"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cleanmaczip --help")

    mkdir "demo"
    (testpath/"demo/hello.txt").write "hi"
    (testpath/"demo/.DS_Store").write ""
    system bin/"cleanmaczip", testpath/"demo"
    assert_path_exists testpath/"demo.zip"
    refute_predicate (testpath/"demo.zip"), :empty?
  end
end
