class Boot2docker141 < Formula
  homepage "https://github.com/boot2docker/boot2docker-cli"
  url "https://github.com/boot2docker/boot2docker-cli.git", :tag => "v1.4.1"
  head "https://github.com/boot2docker/boot2docker-cli.git"

  depends_on "docker141" => :recommended
  depends_on "go" => :build

  def install
    (buildpath + "src/github.com/boot2docker/boot2docker-cli").install Dir[buildpath/"*"]

    cd "src/github.com/boot2docker/boot2docker-cli" do
      ENV["GOPATH"] = buildpath
      system "go", "get", "-d"

      ENV["GIT_DIR"] = cached_download/".git"
      system "make", "goinstall"
    end

    bin.install "bin/boot2docker-cli" => "boot2docker"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/boot2docker</string>
        <string>up</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/boot2docker", "version"
  end
end
