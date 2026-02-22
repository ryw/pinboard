require 'helper'

describe Pinboard::Post do

  describe ".all" do
    let(:posts) { Pinboard::Post.all }

    before do
      stub_get("posts/all").
        to_return(:body => fixture("multiple_posts.xml"),
                  :headers => { 'content-type' => 'text/xml' })
    end

    it "returns a collection" do
      expect(posts.count).to eq(2)
    end

    it "loads posts with valid attributes" do
      post = posts.first
      expect(post.href).to eq("http://foo.com/")
      expect(post.description).to eq("Foo!")
      expect(post.extended).to eq("long description Foo")
      expect(post.tag).to eq(["foo", "bar"])
      expect(post.time).to eq(Time.parse('Tue Jul 26 17:52:04 UTC 2011'))
    end
  end

  describe ".new" do
    let(:post) {
      Pinboard::Post.new(
        :href => 'http://foo.com',
        :description => 'Foo!',
        :extended => "long description Foo",
        :tag => 'rspec pinboard',
        :time => Time.mktime(2011, 1, 1))
    }

    it "initializes attributes" do
      expect(post.href).to eq('http://foo.com')
      expect(post.description).to eq('Foo!')
      expect(post.extended).to eq("long description Foo")
      expect(post.tag).to eq(%w{rspec pinboard})
      expect(post.time).to eq(Time.mktime(2011, 1, 1))
    end
  end
end
