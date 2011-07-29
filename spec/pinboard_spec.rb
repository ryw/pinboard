require 'helper'

describe Pinboard do

  describe "#hello" do

    it "is friendly" do
      Pinboard.new.hello.should == "hi!"
    end

  end

end
