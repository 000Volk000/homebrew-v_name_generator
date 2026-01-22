class VNameGenerator < Formula
  desc "A short, v-starting name generator compatible with cli, ntfy, etc..."
  homepage "https://github.com/000volk000/v_name_generator"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.3/v_name_generator-aarch64-apple-darwin.tar.xz"
      sha256 "b00e94744c5e96cb4622d623506aea4f2bf196e89db4c4f54d2d40eddfb37a9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.3/v_name_generator-x86_64-apple-darwin.tar.xz"
      sha256 "7ba806ab6685031b40a9fd33c8863a9f4ac8b86d438510039574346970fd5b98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.3/v_name_generator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "87f1630bf4c0997904fb9490825816ab3c90e21f99bc91749a4b07c85e27a8f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.3/v_name_generator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2bd3a2e8f0fcb65c4772c6b48504de4d74395ea1af41d43f1f197b981609536"
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
