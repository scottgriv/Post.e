require "webrick"

server = WEBrick::HTTPServer.new(Port: 1337)
server.mount_proc "/" do |req, res|
  res.body = "Ruby Version: " + RUBY_VERSION
end
server.start