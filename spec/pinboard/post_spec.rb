require 'helper'

describe Pinboard::Post do

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
