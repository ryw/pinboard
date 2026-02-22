require 'helper'

describe Pinboard do

  describe ".new" do

    it "returns a Pinboard client" do
      expect(Pinboard.new).to be_a Pinboard::Client
    end

  end

  describe ".endpoint" do

    it "sets the endpoint" do
      expect(Pinboard.endpoint).to eq('https://api.pinboard.in:443/v1')
    end

  end

end
