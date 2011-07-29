require 'helper'

describe Pinboard::Client do

  describe "#posts_all" do
    let(:client) { Pinboard::Client.new(
                     :username => 'user',
                     :password => 'pass') }

    before do
      stub_posts_all
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
