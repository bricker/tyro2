require 'spec_helper'

describe User do
  describe "#send_password_reset" do
    let(:user) { Factory(:user) }
    
    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end
    
    it "saves the time the password reset was requested" do
      user.send_password_reset
      user.reload.password_reset_requested_at.should be_present
    end
    
    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end
  
  it "authenticates user" do
    user = Factory(:user, :email => "authed_user@example.com")
    User.authenticate('authed_user@example.com', 'secret').should == user
  end
  
  it "returns total_strikes" do
    user = Factory(:user)
    user.strikes << Factory(:strike, :severity => 3)
    user.strikes << Factory(:strike, :severity => 2)
    user.total_strikes.should eq(5)
  end
  
end
    
    