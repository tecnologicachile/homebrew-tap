class MailMcp < Formula
  desc "Email MCP server for AI agents over IMAP, SMTP, Microsoft Graph and EWS"
  homepage "https://mail-mcp.tecnologicachile.cl/"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.2/mail-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "a3b706be606b4b035ef73781bb95425e0a116c346daa576b49e7a814dd8e0e97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.2/mail-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "636cded5d80763091fcbaf29e03d0b6637ab8bd350efb8eebee83b464993a636"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.6.2/mail-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "24e168363a5bfd26473b64b4c8c31dba96bd7acae6067fb0104171c2d3a817e5"
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
