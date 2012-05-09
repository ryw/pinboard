require 'helper'

describe Pinboard::Client do
  describe "#posts" do
    let(:client) { Pinboard::Client.new(auth_params) }

    context "when there are many posts" do
      before do
        stub_get("posts/all?").
          to_return(:body => fixture("multiple_posts.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns a collection of posts" do
        expected =
          [
            Pinboard::Post.new(
              :href => "http://foo.com/",
              :description => "Foo!",
              :tag => 'foo bar',
              :time => Time.parse("2011-07-26T17:52:04Z")),
            Pinboard::Post.new(
              :href => "http://bar.com/",
              :description => "Bar!",
              :tag => 'foo bar',
              :time => Time.parse("2011-07-26T17:52:04Z")),
          ]

        client.posts.should == expected
      end
    end

    context "where there is a single post" do
      before do
        stub_get("posts/all?").
          to_return(:body => fixture("single_post.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "still returns an array" do
        client.posts.class.should == Array
      end
    end

    context "when there are no posts" do
      before do
        stub_get("posts/all?").
          to_return(:body => fixture("no_posts.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns an empty array" do
        client.posts.should == []
      end
    end
  end
end
