require 'spec_helper'

describe User do
  describe 'create' do
    describe 'roles' do
      context 'no roles' do
        it 'should belong to player role' do
          user = Fabricate :user
          user.roles.first.name.should == 'player'
        end
      end

      context 'user has a role' do
        it 'should ensure player role' do
          user = Fabricate.build :user
          user.roles = [Role.create(name: 'admin')]
          user.save!
          user.roles.map(&:name).should == ['admin', 'player']
        end
      end
    end

    context 'when registering' do
      let(:user) { User.new }

      it "requires presence of player name" do
        user.player_name = ''
        user.valid?
        user.errors_on(:player_name).should_not be_empty

        user.player_name = "awesometron9000"
        user.valid?
        user.errors_on(:player_name).should be_empty
      end

      it "sets email from player name if email is empty" do
        user.email = ''
        user.player_name = "awesometron4000"
        user.valid?
        user.email.should == "awesometron4000@stu.de.nt"
        user.errors_on(:email).should be_empty
      end

      it 'doesnt set email if player name is blank' do
        user.player_name = "   "
        user.valid?
        user.email.should == ''
      end

      it 'doesnt trash email if validated multiple times' do
        user.player_name = "awesometron3000"
        user.valid?
        user.valid?
        user.email.should == "awesometron3000@stu.de.nt"
      end

      it 'doesnt trash existing email if present' do
        user.player_name = "awesometron1000"
        user.email = "cool@email.com"
        user.valid?
        user.email.should == "cool@email.com"
      end

      it 'requires a unique player name'
    end
  end
end
