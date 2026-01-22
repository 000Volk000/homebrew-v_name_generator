class VNameGenerator < Formula
  desc "A short, v-starting name generator compatible with cli, ntfy, etc..."
  homepage "https://github.com/000volk000/v_name_generator"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.2/v_name_generator-aarch64-apple-darwin.tar.xz"
      sha256 "ce356a64baafbcf67c1c7c049ac09f7dba240f77e3ad9563618fbc3067275b71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.2/v_name_generator-x86_64-apple-darwin.tar.xz"
      sha256 "f32f40f41a2eeb90090baee8ba4e4e5058abe551cf5c83b80fe3ba979ce939ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.2/v_name_generator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2645ba615a69b37679f5823bbb83f687e670a8318c5b9caff6df30fbc2491050"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.2/v_name_generator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fb550b5d2e2d57081a8017ff1b12e56e71c9fa5dcc2ed2bf1ab3c2886e9c713"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "v_name_generator" if OS.mac? && Hardware::CPU.arm?
    bin.install "v_name_generator" if OS.mac? && Hardware::CPU.intel?
    bin.install "v_name_generator" if OS.linux? && Hardware::CPU.arm?
    bin.install "v_name_generator" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
