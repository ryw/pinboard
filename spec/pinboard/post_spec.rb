require 'helper'

describe Pinboard::Post do

  describe ".new" do
    let(:post) {
      Pinboard::Post.new(
        :href => 'http://foo.com',
        :description => 'Foo!',
        :tag => 'rspec pinboard',
        :time => '2011-01-01')
    }

    it "initializes attributes" do
      post.href.should        == 'http://foo.com'
      post.description.should == 'Foo!'
      post.tag.should         == 'rspec pinboard'
      post.time.should        == '2011-01-01'
    end

  end

end
