require 'spec_helper'

describe "Participant_Researcher_Roles" do

  	describe "testing adding user roles" do
			let!(:student2) { Fabricate :user, player_name: 'student_playing_games2', password: 'a password' }
			let!(:admin_role) { Role.create(name: 'admin') }
			let!(:admin) { Fabricate :user, player_name: 'admin_user', password: 'complex admin pass'}

			before do
				stub_request(:any, //).to_return(:status => [200])
			end

			def login_admin
				# Add admin role to admin user so they have admin tools
				if admin.roles.include? admin_role

				else
					admin.roles << admin_role
				end

				# Login in the GUI
				fill_in 'Login',    with: 'admin_user'
				fill_in 'Password', with: 'complex admin pass'
				click_on 'Sign in'
				page.should have_content 'admin_user'
				click_link 'Admin Tools'
				page.should have_content 'Admin Users'
			end

			def set_participant(game, value)
				click_link 'Edit'
				page.should have_content 'student_playing_games'

				@participant = game.participant_role.name

				check_or_uncheck(@participant, value)
			end

			def set_researcher(game, value)
				click_link 'Edit'
				page.should have_content 'student_playing_games'

				@researcher_name = game.researcher_role.name
				check_or_uncheck(@researcher_name, value)
			end

			def check_or_uncheck(role_name, value)
				page.should have_content role_name
	
				if value
					check role_name
				else
					uncheck role_name
				end

				click_on 'Update User'		
			end

			def update_game_roles(gameObject)
				gameObject.researcher_role.name = gameObject.name + "-researcher"
				gameObject.researcher_role.save
				gameObject.participant_role.name = gameObject.name + "-participant"
				gameObject.participant_role.save
			end

			it "Assigns participant role and then the researcher role with two games" do
				@student = Fabricate :user, player_name: 'student_playing_games', password: 'a password' 
    		@game = Fabricate :game, name: 'private_game' 
    		@game2 = Fabricate :game, name: 'private_game_two' 
				visit '/users/sign_in'

				# Login in as admin
				login_admin

				# Update the news of the role so they appear in the GUI
				update_game_roles(@game)
				update_game_roles(@game2)

				# Open the games
				fill_in 'player_name', with: 'student_playing_games'
				click_on 'search'

				# check participant box
				set_participant(@game, true)
				set_participant(@game2, true)
				set_participant(@game2, false)
				set_participant(@game, false)

				# check researcher box
				set_researcher(@game, true)
				set_researcher(@game2, true)
				set_researcher(@game, false)

				# Look at the final product
				click_link 'Edit'
				save_and_open_page
			end

			it "Assigns researcher role and then the participant role" do
				@student = Fabricate :user, player_name: 'student_playing_games', password: 'a password' 
    		@game = Fabricate :game, name: 'private_game' 
				visit '/users/sign_in'

				# Login in as admin
				login_admin

				# Update the news of the role so they appear in the GUI
				update_game_roles(@game)

				# Open the games
				fill_in 'player_name', with: 'student_playing_games'
				click_on 'search'

				# Add the researcher role
				set_researcher(@game, true)

				# Add the participant role
				set_participant(@game, true)
				set_participant(@game, false)
				set_participant(@game, true)

				# Check the final product
				click_link 'Edit'
				save_and_open_page
			end
    end
end
