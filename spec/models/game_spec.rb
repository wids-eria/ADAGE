require 'spec_helper'

describe Game do
  describe 'create' do
    it 'also creates a cancan role' do
      game = Fabricate :game
      Role.where(name: game.name).should_not be_empty
    end 
  end
end
