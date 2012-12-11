module ValidUserRequestHelper
  # for use in request specs

  def sign_in_admin
    Role.create(name: 'player')
    Role.create(name: 'admin')
    @user = Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] 
    visit root_url
    click_link 'login'

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end


end

RSpec.configure do |config|
  config.include ValidUserRequestHelper, :type => :request
end
