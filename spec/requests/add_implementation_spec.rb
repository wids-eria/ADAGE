require 'spec_helper.rb'

describe 'developer game tools' do

  describe 'can add a game and implementation' do 
    it 'adds the game and and implementation' do

      sign_in_developer

      visit games_path

      click_link 'Add Game'

      fill_in 'Name', :with => 'TestGame'
      click_button 'Add'
      
      page.should have_content('TestGame')

      click_link 'TestGame'

      fill_in 'Name', :with => 'Prototype'
      click_button 'Add'

      page.should have_content('Prototype')
      page.should have_content('App Token')
    
    end
  end

end
