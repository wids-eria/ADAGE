require 'spec_helper'

describe Game do
  describe 'create' do
    it 'also creates a reseracher role' do
      game = Fabricate :game
      Role.where(name: game.name, type: 'ResearcherRole').should_not be_empty
    end 
    
    it 'also creates a participant role' do
      game = Fabricate :game
      Role.where(name: game.name, type: 'ParticipantRole').should_not be_empty
    end 

  end
end
