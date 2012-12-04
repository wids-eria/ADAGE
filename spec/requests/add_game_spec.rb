require 'spec_helper.rb'

describe 'add a game' do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }

  describe 'add a game with a unqiuename' do 
    it 'adds the game' do

      sign_in_user

      visit new_game_path

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'

      page.should have_content('TestGame')
    
      save_and_open_page
    end
  end
end
