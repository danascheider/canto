require "spec_helper"

describe User do 
  describe 'validating a user' do 
    before :each do 
      @user = User.new(username: 'frank', password: 'mypasswd1', email: 'frank@example.com')
    end

    it "is invalid without a username" do 
      @user.username = nil
      expect(@user).not_to be_valid
    end

    it "is invalid without a password" do 
      @user.password = nil
      expect(@user).not_to be_valid
    end

    it "is invalid without an e-mail" do 
      @user.email = nil
      expect(@user).not_to be_valid
    end

    it "has a unique username" do 
      @user.save
      new_user = User.new(username: 'frank', password: 'mypasswd2', email: 'felix@example.com')
      expect(new_user).not_to be_valid
    end

    it "has a password at least 8 characters long" do 
      @user.password = "abc1234"
      expect(@user).not_to be_valid
    end

    it "is not an admin by default" do 
      expect(@user).not_to be_admin
    end
  end
end