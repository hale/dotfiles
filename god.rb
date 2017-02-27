God.watch do |w|
  w.name = "ngrok"
  w.start = "/usr/local/bin/ngrok start --all"
  w.keepalive
end
