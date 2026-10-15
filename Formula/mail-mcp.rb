class MailMcp < Formula
  desc "Email MCP server for AI agents over IMAP, SMTP, Microsoft Graph and EWS"
  homepage "https://mail-mcp.tecnologicachile.cl/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.5.0/mail-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "c67204baf1d5bd4f294d3ce2602e8218eb6b4645a542aa6caf57ae9ab6ed7b5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.5.0/mail-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "9007eeed503f8c3e6d38743debf3bf9e4800e7fced5af4b004bac39e73cee473"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/tecnologicachile/mail-mcp/releases/download/v0.5.0/mail-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e79ba635a9b133af8aff918225224a20afe033a1d4bd757350a27a21a400df0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
