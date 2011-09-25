# coding: UTF-8

begin
  require 'rubygems'
ensure
  require 'sinatra'
  require 'haml'
end

$LOAD_PATH << (RUBY_VERSION > '1.9' ? './lib' : 'lib')

PUBLIC_PATH = 'public/'
LOG_PATH    = 'private/log/'

get '/' do
  ''
  # redirect to channel list or login
end

# login
get '/login' do
  ''
end

# channel list
get '/list' do
  @channels = []
  Dir::glob("#{LOG_PATH}*").each {|d|
    next unless File.directory? d
    text   = File.basename(d)
    anchor = URI.encode(text)
    @channels << {:anchor => anchor, :text => text }
  }

  haml :list
end

get '/:channel/' do |channel|
  dir = "#{LOG_PATH}#{channel}"

  if File.exist?(dir) and File.directory?(dir)
    content_type :html
    send_file "#{PUBLIC_PATH}view.html"
  else
    status 404
    ''
  end
end

get '/:channel/:file.:ext' do |channel, file, ext|
  if ext == 'js' or ext == 'css'
    content_type ext
    send_file "#{PUBLIC_PATH}#{file}.#{ext}"
  elsif ext == 'txt'
    content_type ext
    send_file "#{LOG_PATH}#{channel}/#{file}.#{ext}"
  else
    status 404
    ''
  end
end

get '/#:channel/' do |channel|
  dir = "#{LOG_PATH}##{channel}"

  if File.exist?(dir) and File.directory?(dir)
    content_type :html
    send_file "#{PUBLIC_PATH}view.html"
  else
    status 404
    ''
  end
end

get '/#:channel/:file.:ext' do |channel, file, ext|
  if ext == 'js' or ext == 'css'
    content_type ext
    send_file "#{PUBLIC_PATH}#{file}.#{ext}"
  elsif ext == 'txt'
    content_type ext
    send_file "#{LOG_PATH}##{channel}/#{file}.#{ext}"
  else
    status 404
    ''
  end
end

