require 'spec_helper.rb'

describe 'Test the exporting of data as a csv' do

  describe 'export data from the game' do
    it 'produces CSVs' do
      sign_in_researcher_with_game
      @some_player = Fabricate :user
      @join = Assignment.new(user: @some_player, assigner: @user, role: @game.participant_role)
      @join.save
      @some_player.roles << @game.participant_role
      @data = Fabricate :AdaData, user_id: @some_player.id, gameName: @game.name, implementation: @game.implementations.first.name
      visit game_path(@game)

      click_link 'Export all participant data'

      visit game_path(@game)
      click_link @game.implementations.first.name

      visit game_path(@game)
      click_link @game.users.first.player_name + ' data'
    end
  end
end
