require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "EnterTheMatrix" do
  it "responds to the the correct attributes" do
    class User < ActiveRecord::Base
      responds_to_matrix :rate, :rate_type, :default => "0", :with => [ :normal, :saturday, :sunday, :holiday ]
    end

    u = User.new
    u.should respond_to :normal_rate, :saturday_rate, :sunday_rate, :holiday_rate
  end


  it "does not respond to attributes that are not correct" do
    class AnotherUser < ActiveRecord::Base
      responds_to_matrix :rate, :rate_type, :default => "0", :with => [ :saturday, :sunday, :holiday ]
    end

    u = AnotherUser.new
    u.should_not respond_to :normal_rate, :saturday_somethingelse
  end


  it "should raise an error when there is no default value" do
    lambda {
      class YetAnotherUser < ActiveRecord::Base
        responds_to_matrix :rate, :rate_type, :with => [ :saturday, :sunday, :holiday ]
      end
    }.should raise_error
  end


  it "should raise an error when there is no with set" do
    lambda {
      class YetAnotherUser < ActiveRecord::Base
        responds_to_matrix :rate, :rate_type, :default => 0
      end
    }.should raise_error
  end


  it "should return the default value when nothing is found" do
    class ActiveRecord::Base
      def self.where(options = {})
        []
      end
    end

    class Rate < ActiveRecord::Base; end;

    class YetAgainAnotherUser < ActiveRecord::Base
      responds_to_matrix :rate, :rate_type, :default => "0", :with => [ :normal, :saturday, :sunday, :holiday ]
    end

    u = YetAgainAnotherUser.new
    u.normal_rate.should == 0
    u.saturday_rate.should == 0
  end

end
