#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require './youtube.rb'

youtube = Youtube.new


last_clip = nil
loop do
  current_clip = `pbpaste`
  if current_clip != last_clip
    last_clip = current_clip

    if current_clip =~ /\A#{URI::regexp}\z/
      uri = URI(current_clip)
      youtube.notify(uri)
    end
  end

  sleep 2
end
