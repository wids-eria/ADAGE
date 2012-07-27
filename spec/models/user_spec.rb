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
  end
end
