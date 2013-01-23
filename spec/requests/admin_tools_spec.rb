require 'spec_helper.rb'

describe 'Test admin tools' do 

  before do
   @some_researcher = Fabricate :user
   @some_admin = Fabricate :user
   @private_game = Fabricate :game, name: 'private_game' 
   @another_game = Fabricate :game, name: 'another_game'
  end

  describe 'admin grants access' do
    it 'can add and remove researcher roles' do
      sign_in_admin

      click_link 'Users'

      fill_in 'player_name', :with => @some_researcher.player_name
      click_button 'search'

      click_link 'Edit'

      check 'private_game'
      
      click_button 'Update User'

      @some_researcher.role?(ResearcherRole.where(name: @private_game.name).first).should == true

      @some_researcher.role?(Role.where(name: 'player').first).should == true
      
      click_link 'Edit'

      uncheck 'private_game'

      click_button 'Update User'

      @some_researcher.role?(ResearcherRole.where(name: @private_game.name).first).should == false 
    
      @some_researcher.role?(Role.where(name: 'player').first).should == true
    end

    it 'preserves assigner id of other assigned roles' do
      sign_in_admin   

      @aRole = Role.where(name: 'another_game').first 
      @pRole = Role.where(name: 'private_game').first 

      @join = RolesUser.new :assigner => @some_admin, :role => @aRole , :user => @some_researcher 
      @join.save
      
      click_link 'Users'

      fill_in 'player_name', :with => @some_researcher.player_name
      click_button 'search'

      click_link 'Edit'

      check 'private_game'
      
      click_button 'Update User'

      @some_researcher.role?(ResearcherRole.where(name: @private_game.name).first).should == true

      @some_researcher.role?(Role.where(name: 'player').first).should == true

      RolesUser.where(assigner_id: @some_admin.id, role_id: @aRole.id, user_id: @some_researcher.id).count.should == 1
      RolesUser.where(assigner_id: @user.id, role_id: @pRole.id, user_id: @some_researcher.id).count.should == 1
      

    end
  end


end
