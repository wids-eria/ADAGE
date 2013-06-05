require 'spec_helper.rb'

describe 'resetting student password' do
  let!(:student) { Fabricate :user, player_name: 'forgetful_student', password: 'a password' }
  let!(:teacher) { Fabricate :user, player_name: 'random_teacher', password: 'teachers pass' }

  before do
    stub_request(:any, //).to_return(:status => [200])
  end


  it 'authorizes if teacher of student' do
    student.valid_password?('a password').should == true

    visit '/users/sign_in'
    fill_in 'Login',    with: 'random_teacher'
    fill_in 'Password', with: 'teachers pass'
    click_on 'Sign in'

    visit '/users/reset_password_form'
    fill_in 'Player Name',  with: 'forgetful_student'
    fill_in 'New Password', with: 'new password'
    click_on 'Update'

    student.reload.valid_password?('a password').should   == false
    student.reload.valid_password?('new password').should == true

    # test that xyz xyz is a valid devise pass for the user
  end


  it 'warns if password is weak' do
    student.valid_password?('a password').should == true

    visit '/users/sign_in'
    fill_in 'Login',    with: 'random_teacher'
    fill_in 'Password', with: 'teachers pass'
    click_on 'Sign in'

    visit '/users/reset_password_form'
    fill_in 'Player Name',  with: 'forgetful_student'
    fill_in 'New Password', with: 'a'
    click_on 'Update'

    page.should have_content 'too short'

    student.reload.valid_password?('a password').should == true
    student.reload.valid_password?('a').should == false

    # test that xyz xyz is a valid devise pass for the user

  end

  it 'does not if not teacher of student' do
    student.valid_password?('a password').should == true

    stub_request(:any, //).to_return(:status => [401])

    visit '/users/sign_in'
    fill_in 'Login',    with: 'random_teacher'
    fill_in 'Password', with: 'teachers pass'
    click_on 'Sign in'

    visit '/users/reset_password_form'
    fill_in 'Player Name',  with: 'forgetful_student'
    fill_in 'New Password', with: 'new password'
    click_on 'Update'

    # should have errors
    page.should have_content 'Not Authorized'

    student.reload.valid_password?('a password').should   == true
    student.reload.valid_password?('new password').should == false
  end


  it 'warns if user does not exist' do
    student.valid_password?('a password').should == true

    visit '/users/sign_in'
    fill_in 'Login',    with: 'random_teacher'
    fill_in 'Password', with: 'teachers pass'
    click_on 'Sign in'

    visit '/users/reset_password_form'
    fill_in 'Player Name',  with: 'i dont exist anywhere'
    fill_in 'New Password', with: 'new password'
    click_on 'Update'

    page.should have_content 'Invalid Player'
  end

end
