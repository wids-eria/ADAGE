module ValidUserRequestHelper
  # for use in request specs

  def sign_in_admin
    Role.create(name: 'player')
    Role.create(name: 'admin')
    @user = Fabricate :user, player_name: 'admin', password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] 
    visit root_url
    click_link 'login'

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end

  def sign_in_player
    Role.create(name: 'player')
    Role.create(name: 'admin')
    @user = Fabricate :user, player_name: 'player', password: 'pass1234', roles: [Role.where(name: 'player').first] 
    visit root_url
    click_link 'login'

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end

  def sign_in_researcher_with_game
    Role.create(name: 'player')
    Role.create(name: 'admin')
    @game = Fabricate :game
    @user = Fabricate :user, player_name: 'researcher', password: 'pass1234', roles: [@game.researcher_role] 
    puts @user.roles.inspect
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
