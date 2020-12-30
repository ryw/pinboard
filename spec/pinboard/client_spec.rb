require 'helper'

describe Pinboard::Client do
  describe "#posts" do
    let(:client) { Pinboard::Client.new }

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
    let(:client) { Pinboard::Client.new }

    context "when there are many posts" do
      before do
        stub_get("posts/delete?url=http://bar.com/").
          to_return(:body => fixture("deleted.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "succeeds without raising an error" do
        expect{client.delete("http://bar.com/")}.to_not raise_error
      end
    end

    context "when specified url is not found" do
      before do
        stub_get("posts/delete?url=http://baz.com/").
          to_return(:body => fixture("not_found.xml"),
                    :headers => { 'content-type' => 'text/xml' })
      end

      it "throws an error" do
        expect{client.delete("http://baz.com/")}.to raise_error(Pinboard::Error, 'item not found')
      end
    end
  end

  describe "#add" do
    let(:client) do
      Pinboard::Client.new
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
    let(:client) { Pinboard::Client.new }

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
    let(:client) { Pinboard::Client.new }

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
    let(:client) { Pinboard::Client.new }

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

  describe "#notes_list" do
    let(:client) { Pinboard::Client.new }
    before do
      stub_get("notes/list?").
        to_return(:body => fixture("notes_list.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns a list of notes" do
      notes = client.notes_list
      notes.size.should == 2
      notes.first.title.should == "Paul Graham on Hirin' The Ladies"
    end
  end

  describe "#user_secret" do
    let(:client) { Pinboard::Client.new }
    before do
      stub_get("user/secret?").
        to_return(:body => fixture("user_secret.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns the user's secret RSS key" do
      secret = client.user_secret
      secret.should == "6493a84f72d86e7de130"
    end
  end

  describe "#user_api_token" do
    let(:client) { Pinboard::Client.new }
    before do
      stub_get("user/api_token?").
          to_return(:body => fixture("user_api_token.xml"),
                    :headers => { 'content-type' => 'text/xml' })
    end

    it "returns the user's API token" do
      token = client.user_api_token
      token.should == "XOG86E7JIYMI"
    end
  end

  describe "#get" do
    let(:client) { Pinboard::Client.new }

    context "when there are many posts" do
      before do
        stub_get("posts/get?").
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

        client.get.should == expected
      end
    end

    context "where there is a single post" do
      before do
        stub_get("posts/get?").
            to_return(:body => fixture("single_post.xml"),
                      :headers => { 'content-type' => 'text/xml' })
      end

      it "still returns an array" do
        client.get.class.should == Array
      end
    end

    context "when there are no posts" do
      before do
        stub_get("posts/get?").
            to_return(:body => fixture("no_posts.xml"),
                      :headers => { 'content-type' => 'text/xml' })
      end

      it "returns an empty array" do
        client.get.should == []
      end
    end
  end

  describe "#suggest" do
    let(:client) { Pinboard::Client.new }
    let(:url) { 'http://example.com' }

    context "when there are many popular and recommended tags" do
      before do
        stub_get("posts/suggest").
            with(:query => { 'url' => url }).
            to_return(:body => fixture("multiple_suggest.xml"),
                      :headers => { 'content-type' => 'text/xml' })
      end

      it "returns a collections of tags" do
        suggest = client.suggest(url)
        suggest[:popular].should == %w[blog blogs]
        suggest[:recommended].should == %w[writing weblog]
      end
    end

    context "when there are single popular and recommended tags" do
      before do
        stub_get("posts/suggest?").
            with(:query => { 'url' => url }).
            to_return(:body => fixture("single_suggest.xml"),
                      :headers => { 'content-type' => 'text/xml' })
      end

      it "still returns an array" do
        suggest = client.suggest(url)
        suggest[:popular].class.should == Array
        suggest[:recommended].class.should == Array
      end
    end

    context "when there are no popular and recommended tags" do
      before do
        stub_get("posts/suggest?").
            with(:query => { 'url' => url }).
            to_return(:body => fixture("no_suggest.xml"),
                      :headers => { 'content-type' => 'text/xml' })
      end

      it "returns an empty array" do
        suggest = client.suggest(url)
        suggest[:popular].should == []
        suggest[:recommended].should == []
      end
    end
  end
end
