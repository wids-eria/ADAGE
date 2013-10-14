require 'spec_helper.rb'

describe 'Oauth with google+' do

  it 'creates account for new users' do
    visit root_url
    click_link 'Connect with Google+'

    page.should have_content('Mock Man')
    @user = User.where(player_name: 'Mock Man').first
    puts @user.social_access_tokens.where(provider: 'google_oauth2').first.inspect
    @user.social_access_tokens.where(provider: 'google_oauth2').first.should_not be_nil

  end

  it 'merges info into existing users' do
    Role.create(name: 'player')
    Role.create(name: 'admin')
    @user = Fabricate :user, player_name: 'Mock Man', email: 'mock@nomail.com', password: 'pass1234', roles: [Role.where(name: 'player').first]
    visit root_url

    click_link 'Connect with Google+'

    page.should have_content('Mock Man')
    @user.social_access_tokens.where(provider: 'google_oauth2').first.should_not be_nil
  end

  it 'handles invalid credentials' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    visit root_url
    click_link 'Connect with Google+'

    page.should have_content('Could not authorize you from Google oauth2 because "Invalid credentials".')
  end
end