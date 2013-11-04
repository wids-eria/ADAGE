require 'spec_helper.rb'

describe 'add a game' do

  describe 'add a game with a unqiuename' do 
    it 'adds the game' do

      sign_in_admin

      visit new_game_path

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'
      
      page.should have_content('TestGame')
    
    end
  end

  describe 'try to add a game with the same name' do 
    it 'it does not add the game' do

      sign_in_admin

      visit new_game_path

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'

      page.should have_content('TestGame')

      visit new_game_path

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'

      page.should have_content('Game name is not unique')
    
    end
  end

end
