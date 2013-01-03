require 'spec_helper.rb'

describe 'add a game' do

  describe 'add a game with a unqiuename' do 
    it 'adds the game' do

      sign_in_admin
     
      click_link 'Games'

      click_link 'Add A Game' 

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

  describe 'add a schema to the game' do
    it 'adds a schema' do
      sign_in_admin

      visit new_game_path

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'

      click_link 'TestGame'
      click_link 'Edit'

      fill_in 'schema_name', :with => 'BETA_BUILD'
      click_button 'Add'

      page.should have_content('BETA_BUILD')
    
    end
  end

end
