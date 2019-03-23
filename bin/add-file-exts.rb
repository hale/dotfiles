#!/usr/bin/ruby

require 'fileutils'

EXTENSIONS = {
  'application/msword' => 'docx',
  'application/pdf' => 'pdf',
  'application/zip' => 'zip',
  'image/png' => 'png',
  'text/plain' => 'txt'
}.freeze

PATH = ARGV[0] || './*'

Dir.glob(PATH).each do |file|
  next unless File.file?(file)
  next if file[2..-1].include?(".")

  type = IO.popen(['file', '--brief', '--mime-type', file], &:read).chomp
  ext = EXTENSIONS.fetch(type)

  if ext
    FileUtils.cp(file, "#{file}.#{ext}")
  else
    STDERR.puts "Unhandled file type #{type} for #{file}"
  end
end
