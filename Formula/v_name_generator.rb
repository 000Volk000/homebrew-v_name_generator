class VNameGenerator < Formula
  desc "A short, v-starting name generator compatible with cli, ntfy, etc..."
  homepage "https://github.com/000volk000/v_name_generator"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.5/v_name_generator-aarch64-apple-darwin.tar.xz"
      sha256 "1dabc2c48f06f25fb31eb46aa2a2a1d1dc3dc70a55bcdf9488aa5bbde4ec3c6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.5/v_name_generator-x86_64-apple-darwin.tar.xz"
      sha256 "e6fdda6ed62c28cfca98557fd8e1f696f2f682d7de04ba4cf4227d66ceb3621b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.5/v_name_generator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e220405f3c6c2d10771b60ce29cb55d1d0e902b181d2ebeb8dcd89b1431618a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.5/v_name_generator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8bd27e5833666bd77cb92e967358907672276e14f6921a40be6e14ad693c7e12"
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
