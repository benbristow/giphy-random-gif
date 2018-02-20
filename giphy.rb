#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open-uri'
require 'json'

class Giphy
  API_URL = 'http://api.giphy.com/v1/gifs/'
  API_KEY = 'dc6zaTOxFJmzC'

  def random_gif(tag)
    request_uri = build_request_uri 'random', tag: tag
    json = get_request request_uri
    !json['data'].empty? ? json['data']['image_original_url'] : nil
  end

  private

  def get_request(uri)
    JSON.parse(open(uri).read)
  end

  def build_request_uri(path, params)
    params[:api_key] = API_KEY
    encoded = URI.encode_www_form(params)
    "#{API_URL}#{path}?#{encoded}"
  end
end

class RandomGiphy
  def initialize
    puts "Searching Giphy for random GIF with tag #{tag}..."
    gif_url = Giphy.new.random_gif tag
    throw "No GIF found for tag #{tag} :(" if gif_url.nil?
    save_file!(gif_url)
  end

  private

  def save_file!(gif_url)
    File.open("#{file_name}.gif", 'wb') do |output_file|
      open(gif_url, 'rb') do |gif_file|
        output_file.write(gif_file.read)
        puts "GIF saved to #{file_name}.gif"
      end
    end
  end

  def file_name
    tag.tr(' ', '-')
  end

  def tag
    input = ARGV.join(' ')
    throw 'No tag provided' if input.empty?
    input
  end
end

RandomGiphy.new
