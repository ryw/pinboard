require 'pinboard'
require 'rspec'
require 'webmock/rspec'

def auth_params
  { :username => 'user',
    :password => 'pass' }
end

def a_get(path)
  a_request(:get, Pinboard.endpoint + path)
end

def stub_get(path)
  stub_request(:get, uri(path))
end

def stub_post(path)
  stub_request(:post, uri(path))
end

def uri(path)
  "https://#{auth_params[:username]}:#{auth_params[:password]}@api.pinboard.in/v1/#{path}"
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
