class VNameGenerator < Formula
  desc "A short, v-starting name generator compatible with cli, ntfy, etc..."
  homepage "https://github.com/000volk000/v_name_generator"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.2.0/v_name_generator-aarch64-apple-darwin.tar.xz"
      sha256 "99d698ccf364fa8d4c393ca2fb97fbef079670a42b1639f95ec8da1191a7d27b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.2.0/v_name_generator-x86_64-apple-darwin.tar.xz"
      sha256 "9b51d51b529c7562fcc3fe262b3bbbe8a5b706471042556fdbabcd97811f834b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.2.0/v_name_generator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a3a872f860cbe165a172cb3198ab8af9a4221aa4b1e40235ba2955599b8a67a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.2.0/v_name_generator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92d5632946acdecef3f86f6a5f2be1804cf9509d548375aa88f09f144d3419a1"
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
