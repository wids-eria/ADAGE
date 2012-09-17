require 'spec_helper'

describe User do
  describe 'create' do
    describe 'roles' do
      context 'no roles' do
        it 'should belong to player role' do
          user = User.create!(email: 'foo@example.com', password: 'password', password_confirmation: 'password')
          user.roles.first.name.should == 'player'
        end
      end

      context 'user has a role' do
        it 'should ensure player role' do
          user = User.new(email: 'foo@example.com', password: 'password', password_confirmation: 'password')
          user.roles = [Role.create(name: 'admin')]
          user.save!
          user.roles.map(&:name).should == ['admin', 'player']
        end
      end
    end

    it "requires presence of player name" do
      user = User.new
      user.player_name = nil
      user.valid?
      user.errors_on(:player_name).should_not be_empty

      user.player_name = "awesometron9000"
      user.valid?
      user.errors_on(:player_name).should be_empty
    end

    it "does not require presence of email" do
      user = User.new
      user.email = nil
      user.valid?
      user.errors_on(:email).should be_empty
    end
  end
end
