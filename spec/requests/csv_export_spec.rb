require 'spec_helper.rb'

describe 'Test the exporting of data as a csv' do

  describe 'export data from the game' do
    it 'produces CSVs' do
      sign_in_researcher_with_game
      @some_player = Fabricate :user
      @join = RolesUser.new(user: @some_player, assigner: @user, role: @game.participant_role)
      @join.save
      @data = Fabricate :AdaData, user_id: @some_player.id, gameName: @game.name, schema: @game.schemas.first.name
      puts @game.schemas.inspect
      visit game_path(@game)
 
      click_link 'Export all participant data'  
      
      click_link @game.schemas.first.name  
      
      click_link @game.users.first.player_name  
    end
  end
end
