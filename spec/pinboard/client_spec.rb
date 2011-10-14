require 'helper'

describe Pinboard::Client do
  describe "#posts" do
    let(:client) { Pinboard::Client.new(auth_params) }

    before do
      stub_get("posts/all").
        to_return(:body => fixture("posts_all.xml"),
        :headers => { 'content-type' => 'text/xml' })
    end

    it "returns a collection of posts" do
      expected = [
        Pinboard::Post.new(
          :href => "http://foo.com/",
          :description => "Foo!",
          :tag => 'foo bar',
          :time => Time.parse("2011-07-26T17:52:04Z")),
        Pinboard::Post.new(
          :href => "http://bar.com/",
          :description => "Bar!",
          :tag => 'foo bar',
          :time => Time.parse("2011-07-26T17:52:04Z"))
      ]

      client.posts.should == expected
    end
  end
end
