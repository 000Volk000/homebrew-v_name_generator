class VNameGenerator < Formula
  desc "A short, v-starting name generator compatible with cli, ntfy, etc..."
  homepage "https://github.com/000volk000/v_name_generator"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.4/v_name_generator-aarch64-apple-darwin.tar.xz"
      sha256 "a4ceeb764192be186aab099adeef984a5caee932969c0883733572dfeaa47df1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.4/v_name_generator-x86_64-apple-darwin.tar.xz"
      sha256 "9b2a95e9b01cb296623e37ebf682459244f89c237d537d8414f89500ced4a0b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.4/v_name_generator-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57bf405671ce7703f1d32ac11875023dd84b10790d5dc824a1bbfa068d4e97e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/v_name_generator/releases/download/v1.0.4/v_name_generator-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bcd91657f5416b75f689f07189ebd5bfee5223251f972da2662f5e98b8cef47"
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
