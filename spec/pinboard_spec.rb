require 'helper'

describe Pinboard do

  describe ".new" do

    it "returns a Pinboard client" do
      Pinboard.new.should be_a Pinboard::Client
    end

  end

  describe ".endpoint" do

    it "sets the endpoint" do
      Pinboard.endpoint.should == 'https://api.pinboard.in:443/v1'
    end

  end

end
