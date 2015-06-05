#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require "rubygems"
require "json"

class Youtube
  $api_key = "AIzaSyDlOGSHpgOr3spt84IP6OX1EnQjzkPotQE"

  def is_youtube?(uri)
    uri.host.include? "youtube.com"
  end

  def youtube_video_id (uri)
    params = URI::decode_www_form(uri.query).to_h

    params["v"]
  end

  def youtube_video_title (api_key, video_id)
    uri = URI("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{video_id}&key=#{api_key}")

    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri, {'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
    })
    response = https.request(req)
    json = JSON.parse(response.body)

    json["items"].first["snippet"]["title"]
  end

  def notify(uri)
    if is_youtube?(uri)
      video_id = youtube_video_id(uri)
      video_title = youtube_video_title($api_key, video_id)
      command = "/usr/local/bin/youtube-dl -o \"~/Downloads/%(title)s-%(id)s.%(ext)s\"  --ignore-errors --continue \"#{uri.to_s}\""

      `terminal-notifier -title 'Download video?' -message '#{video_title}' -execute '#{command}'`
      puts command
    end
  end
end




