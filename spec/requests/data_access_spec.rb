require 'spec_helper.rb'

describe 'Test access to game data' do

  before do
    @some_player = Fabricate :user
    @private_game = Fabricate :game, name: 'private_game'
    @data = Fabricate :AdaData, user_id: @some_player.id, gameName: @private_game.name
  end 

  describe 'admin role' do
    it 'can see all data, users and games' do 
      sign_in_admin
      
      visit games_path

      page.should have_content(@private_game.name)

      visit data_path

      page.should_not have_content('You are not authorized to access this page')

      visit users_path 

      page.should have_content(@some_player.email)
      
    end
  end

  describe 'player role' do
    it 'can not see all data, users and games' do 
      sign_in_player

      visit games_path

      page.should_not have_content(@private_game.name)
      
      visit game_path(@private_game)

      page.should_not have_content(@private_game.name)

      visit data_path

      page.should have_content('You are not authorized to access this page')

      visit users_path 

      page.should_not have_content(@some_player.email)
      
    end
  end

  describe 'researcher role' do
    it 'can see games they are doing research on and can not see users or data' do 
      sign_in_researcher_with_game

      visit games_path

      save_and_open_page
      page.should_not have_content(@private_game.name)
      page.should have_content(@game.name)
      
      visit game_path(@private_game)
      page.should_not have_content(@private_game.name)
      
      visit game_path(@game)
      page.should have_content(@game.name)

      visit data_path

      page.should have_content('You are not authorized to access this page')

      visit users_path 

      page.should_not have_content(@some_player.email)
      
    end
  end


end
