module AuthMacros
  def login(user = nil)
    user ||= Factory(:user)
    visit cp_login_path
    fill_in "email", :with => user.email
    fill_in "password", :with => "secret"
    click_button "Login"
    page.current_path.should eq(cp_root_path)
    @current_user = user
  end
  
  def constant_password(password)
    User.any_instance.stubs(:create_password).returns(password)
  end
  
  def check_permissions(user, *args)
    admin = Factory(:user, :permissions => Permission.create(:title => "admin"))
    another_user = Factory(:user, :name => "Jane Doe", :email => "janed@example.com")
    args.each do |permission|
      user.permissions.create(:title => permission)
    end
  end
  
end