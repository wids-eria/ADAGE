require 'spec_helper.rb'

describe 'add participants to a game' do


  describe 'researcher finds players and selects them' do
    it 'adds a participant role to the player for this game' do
      sign_in_researcher_with_game

      @some_player = Fabricate :user
      @data = Fabricate :AdaData, gameName: @game.name, user_id: @some_player.id

      visit games_path

      click_link @game.name

      click_button 'Search'

      page.should have_content(@some_player.player_name)

      check @some_player.player_name
      
      click_button 'Update Participants'


      page.should have_content(@game.name)
      page.should have_content(@some_player.player_name)



    end
    
  end

end
