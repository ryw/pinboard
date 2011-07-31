require 'helper'

describe Pinboard::Client do

  describe "#posts_all" do
    let(:client) { Pinboard::Client.new(auth_params) }

    before do
      stub_get("posts/all").
        to_return(:body => fixture("posts_all.xml"),
        :headers => { 'content-type' => 'text/xml' })
    end

    it "returns a collection of posts" do
      client.all_posts.count.should == 2
    end

    it "loads posts with valid attributes" do
      post = client.all_posts.first
      post.href.should_not be_nil
      post.description.should_not be_nil
      post.tag.should_not be_nil
      post.time.should_not be_nil
    end

  end

end
