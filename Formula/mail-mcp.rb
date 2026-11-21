class MailMcp < Formula
  desc "Email MCP server for AI agents over IMAP, SMTP, Microsoft Graph and EWS"
  homepage "https://mail-mcp.tecnologicachile.cl/"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.0/mail-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "cad3e539bd9883e75b8318aec1cef84bf484cd7f235b1e9977f90bfcd4e7be61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.0/mail-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "46dff30096506f0a32d8aa87e9cb5dd4f3ab7377aac622bb613278ca86730177"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.7.0/mail-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "276f7a71aac6218aa9601d0154e159897e03f9205e7fb39f62ee41aa68e6d0ce"
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
