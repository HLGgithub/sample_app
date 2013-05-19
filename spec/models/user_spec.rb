require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate)}


  it { should be_valid }

  describe "has a password that is blank" do
    before { @user.password = @user.password_confirmation = " "}
    it {should_not be_valid}
  end

  describe "has a password that is nil, most likey from console input, since this can't happen on the web.." do
    before { @user.password_confirmation = nil}
    it {should_not be_valid}
  end

  
  describe "has a name that is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "has an email that is not present" do
    	before { @user.email = " " }
    	it { should_not be_valid }
  end

  describe "has a name that is too long" do
    	before { @user.name = "a" * 51 }
    	it { should_not be_valid }
  end

   describe "has an email format that is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "has an email format that is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "has an email address that has already been used" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }

  end

  describe "calls authenticate" do
    before { @user.save }
    let (:found_user) { User.find_by_email(@user.email) }

    describe "and password is the user's real password" do
      it {should == found_user.authenticate(@user.password)}
    end

    describe "and password is not the user's real password" do

      let(:user_with_wrong_password) {found_user.authenticate("This_Is_An_Invalid_Password")}
      
      # The user should not be the same as the test user
      it {should_not == user_with_wrong_password}

      # Furthermore, no user should be found
      specify {user_with_wrong_password.should be_false}
    end

    describe "has a password that is too short" do
      before {@user.password = @user.password_confirmation = "a"*5}
      it {should_not be_valid }
    end

  end


  describe "is being tested for an email that was downcased before save" do
    let(:mixed_case_email) { "mixedEmail@fooBar.Com" }

    it "and therefore should have a lower case email" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end

  end


  describe "handles remember tokens" do
    before { @user.save }
    its (:remember_token) {should_not be_blank}
    
  end

  


end