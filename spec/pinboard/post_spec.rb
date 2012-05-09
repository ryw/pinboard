require 'helper'

describe Pinboard::Post do

  describe ".all" do
    let(:posts) { Pinboard::Post.all(auth_params) }

    before do
      stub_get("posts/all").
        to_return(:body => fixture("multiple_posts.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns a collection" do
      posts.count.should == 2
    end

    it "loads posts with valid attributes" do
      post = posts.first
      post.href.should == "http://foo.com/"
      post.description.should == "Foo!"
      post.tag.should == ["foo", "bar"]
      post.time.should == Time.parse('Tue Jul 26 17:52:04 UTC 2011')
    end
  end

  describe ".new" do
    let(:post) {
      Pinboard::Post.new(
        :href => 'http://foo.com',
        :description => 'Foo!',
        :tag => 'rspec pinboard',
        :time => Time.mktime(2011, 1, 1))
    }

    it "initializes attributes" do
      post.href.should        == 'http://foo.com'
      post.description.should == 'Foo!'
      post.tag.should         == %w{rspec pinboard}
      post.time.should        == Time.mktime(2011, 1, 1)
    end
  end
end

