class MailMcp < Formula
  desc "Email MCP server for AI agents over IMAP, SMTP, Microsoft Graph and EWS"
  homepage "https://mail-mcp.tecnologicachile.cl/"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.1/mail-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d8aedc770995d9e544c6384f0876d7ec109973db97dee9d11d412f66b77f2e03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.1/mail-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "9e647c318054974a6a2b8d15caa6c88178eb2c35f95e06874b135e412e0b55a3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.1/mail-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2b62c8d594454e4cf417165034fa11a70b87ac05aa386423a93f0a5cc2014b9f"
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
