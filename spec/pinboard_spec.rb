require 'helper'

describe Pinboard do

  describe ".new" do

    it "returns a Pinboard client" do
      Pinboard.new.should be_a Pinboard::Client
    end

  end

end
