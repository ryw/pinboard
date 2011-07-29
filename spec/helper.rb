require 'pinboard'
require 'rspec'
require 'webmock/rspec'

def stub_posts_all
  stub_request(:get, "https://user:pass@api.pinboard.in/v1/posts/all").
     to_return(:status => 200, :headers => { 'content-type' => 'text/xml' },
               :body => %Q|<?xml version="1.0" encoding="UTF-8" ?><posts user="user"><post href="http://foo.com/" time="2011-07-26T17:52:04Z" description="Foo!" extended="" tag="" hash="0c85c54332a588d18a85e963257e8fbc" meta="5cea9129d6a4f10e4790cc8665c48423" toread="yes" /><post href="http://bar.com/" time="2011-07-26T17:52:04Z" description="Bar!" extended="" tag="" hash="0c85c54332a588d18a85e963257e8fbc" meta="5cea9129d6a4f10e4790cc8665c48423" toread="yes" /></posts>|)
end
