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
              :toread => 'yes',
              :time => Time.parse("2011-07-26T17:52:04Z")),
            Pinboard::Post.new(
              :href => "http://bar.com/",
              :description => "Bar!",
              :extended => "long description Bar",
              :tag => 'foo bar',
              :toread => 'yes',
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

      it "succeeds without raising an error" do
        expect{client.delete(:url => "http://bar.com/")}.to_not raise_error
      end
    end

    context "when specified url is not found" do
      before do
        stub_get("posts/delete?url=http://baz.com/").
          to_return(:body => fixture("not_found.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "throws an error" do
        expect{client.delete(:url => "http://baz.com/")}.to raise_error(Pinboard::Error, 'item not found')
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

      context 'and toread is set to true' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&toread=yes").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :toread => true)}.to_not raise_error
        end
      end

      context 'and toread is set to false' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&toread=no").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :toread => false)}.to_not raise_error
        end
      end

      context 'and replace is set to true' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&replace=yes").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :replace => true)}.to_not raise_error
        end
      end

      context 'and replace is set to false' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&replace=no").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :replace => false)}.to_not raise_error
        end
      end

      context 'and shared is set to true' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&shared=yes").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :shared => true)}.to_not raise_error
        end
      end

      context 'and shared is set to false' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&shared=no").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/", :description => 'title', :shared => false)}.to_not raise_error
        end
      end

      context 'and replace, shared, and toread are all set to true' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&replace=yes&shared=yes&toread=yes").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/",
                             :description => 'title',
                             :replace => true,
                             :shared => true,
                             :toread => true)}.to_not raise_error
        end
      end

      context 'and replace, shared, and toread are all set to false' do
        before do
          stub_post("posts/add?url=http://baz.com/&description=title&replace=no&shared=no&toread=no").
            to_return(:body => fixture("created.xml"),
                      :headers => { 'content-type' => 'text/xml' })
        end

        it "succeeds without raising an exception" do
          expect {client.add(:url => "http://baz.com/",
                             :description => 'title',
                             :replace => false,
                             :shared => false,
                             :toread => false)}.to_not raise_error
        end
      end
    end
  end

  describe "#update" do
    let(:client) { Pinboard::Client.new(auth_params) }

    before do
      stub_get("posts/update?").
        to_return(:body => fixture("post_update.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns the time of last update" do
      expected = Time.parse "2013-04-20 13:58:56 +0200"

      client.update.should == expected
    end
  end

  describe "#recent" do
    let(:client) { Pinboard::Client.new(auth_params) }

    before do
      stub_get("posts/recent?").
        to_return(:body => fixture("multiple_posts.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns recent items" do
      expected = [
          Pinboard::Post.new(
            :href => "http://foo.com/",
            :description => "Foo!",
            :extended => "long description Foo",
            :tag => 'foo bar',
            :toread => 'yes',
            :time => Time.parse("2011-07-26T17:52:04Z")),
            Pinboard::Post.new(
              :href => "http://bar.com/",
              :description => "Bar!",
              :extended => "long description Bar",
              :tag => 'foo bar',
              :toread => 'yes',
              :time => Time.parse("2011-07-26T17:52:04Z")),
      ]

      client.recent.should == expected
    end
  end

  describe "#dates" do
    let(:client) { Pinboard::Client.new(auth_params) }

    context "unfiltered" do
      before do
        stub_get("posts/dates?").
          to_return(:body => fixture("dates.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns a list of dates with the number of posts at each date" do

        expected = {
          "2013-04-19" => 1,
          "2013-04-18" => 2,
          "2013-04-17" => 3
        }

        client.dates.should == expected
      end
    end

    context "filtered by tag" do
      before do
        stub_get("posts/dates?tag=tag").
          to_return(:body => fixture("dates_filtered.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "returns a list of dates with the number of posts at each date" do

        expected = {
          "2013-04-19" => 1,
          "2013-04-18" => 2,
          "2013-04-17" => 3
        }

        client.dates("tag").should == expected
      end
    end
  end
end
