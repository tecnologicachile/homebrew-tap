class MailMcp < Formula
  desc "Email MCP server for AI agents over IMAP, SMTP, Microsoft Graph and EWS"
  homepage "https://mail-mcp.tecnologicachile.cl/"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.2/mail-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "9199079553b9250e7a731e0f9013d76b42451656afd89c79dc22597586c5432b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.2/mail-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "450c5c52514ace49df486511a3ce33d68348f037f47dc10e0cd5ad6e100422b6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.2/mail-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d3e56a36a7f4bc842afa87f4c44910fdc6ce1fa766bc7d5db3f264818380e577"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mail-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mail-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mail-mcp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
