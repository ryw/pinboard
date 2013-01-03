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
              :extended => "long description Foo",
              :tag => 'foo bar',
              :time => Time.parse("2011-07-26T17:52:04Z")),
            Pinboard::Post.new(
              :href => "http://bar.com/",
              :description => "Bar!",
              :extended => "long description Bar",
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

  describe "#delete" do
    let(:client) { Pinboard::Client.new(auth_params) }

    context "when there are many posts" do
      before do
        stub_get("posts/delete?url=http://bar.com/").
          to_return(:body => fixture("deleted.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns true" do
        client.delete(:url => "http://bar.com/").should == true
      end
    end

    context "when specified url is not found" do
      before do
        stub_get("posts/delete?url=http://baz.com/").
          to_return(:body => fixture("not_found.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns false" do
        client.delete(:url => "http://baz.com/").should be_false
      end
    end
  end

  describe "#add" do
    let(:client) do
      Pinboard::Client.new(auth_params)
    end

    context "where the post does not exist yet" do

      context 'and the url is missing' do
        before do
          stub_post("posts/add").
            to_return(:body => fixture("missing_url.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "throws an error" do
          expect { client.add(nil) }.to raise_error
        end
      end

      context 'and the description is missing' do
        before do
          stub_post("posts/add?url=http://baz.com/").
            to_return(:body => fixture("missing_description.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "throws an error" do
          expect { client.add(:url => "http://baz.com/") }.to raise_error(Pinboard::Error, 'missing description')
        end
      end

      context 'and the description is present' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title')}.to_not raise_error
        end
      end
    end
  end
end
