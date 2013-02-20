require 'spec_helper'

describe User do
  describe 'create' do
    it 'has case insensitive email and player name'
    it 'doesnt allow two of the same email or player name'

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

    context 'when registering with player_name' do
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
        user.player_name.should == "awesometron1000"
      end
    end

    context 'when registering with email' do
      let(:user) { User.new }

      it "requires presence of player name or email" do
        user.player_name = ''
        user.email = ''
        user.valid?
        user.errors_on(:email).should_not be_empty

        user.email = "awesometron9000@email.com"
        user.valid?
        user.errors_on(:email).should be_empty
      end

      it "sets player name from email if player name is empty" do
        user.email = 'awesometron4000@email.com'
        user.player_name = ''
        user.valid?
        user.player_name.should == 'awesometron4000'
        user.errors_on(:player_name).should be_empty
      end

      it 'doesnt set player name if email is blank' do
        user.email = "   "
        user.valid?
        user.player_name.should == ''
      end

      it 'doesnt trash player name if validated multiple times' do
        user.email = "awesometron3000@email.com"
        user.valid?
        user.valid?
        user.player_name.should == "awesometron3000"
      end

      it 'doesnt trash existing player name if present' do
        user.player_name = "awesometron1000"
        user.email = "cool@email.com"
        user.valid?
        user.email.should == "cool@email.com"
        user.player_name.should == "awesometron1000"
      end

    end
  end
end
