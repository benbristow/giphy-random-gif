#!/usr/bin/env ruby

require 'open-uri'
require 'json'

class Giphy
  API_URL = "http://api.giphy.com/v1/gifs/"
  API_KEY = "dc6zaTOxFJmzC"

  def random_gif tag
    request_uri = build_request_uri "random", {:tag => tag}
    json = get_request request_uri
    json["data"].length > 0 ? json["data"]["image_original_url"] : nil
  end

  private

  def get_request uri
    JSON.parse(open(uri).read)
  end

  def build_request_uri path, params
    params[:api_key] = API_KEY
    encoded = URI.encode_www_form(params)
    "#{API_URL}#{path}?#{encoded}"
  end

end

def main
  tag = ARGV.join(" ")

  if tag.nil? || tag == ""
    puts "No tag provided"
    return
  end

  puts "Searching GIPHY for random GIF with tag #{tag}..."

  giphy = Giphy.new
  gif_url = giphy.random_gif tag

  if gif_url.nil?
    puts "No GIF found for tag #{tag} :("
    return
  else
    puts "Found GIF. Downloading!"
    save_file_name = tag.gsub(' ', '-')
    File.open("#{save_file_name}.gif", "wb") do |save_file|
      open(gif_url, "rb") do |gif_file|
        save_file.write(gif_file.read)
        puts "GIF saved to #{save_file_name}.gif"
      end
    end
  end
end

main
