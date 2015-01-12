#ADAGE Server Installation guide (BETA)

This guide will walk you through installation of a local ADAGE server on either Linux or Mac OS. Windows installation might be more challenging and is not recommended. 

This assumes you have git installed already.

1. Fork the ADAGE repository and clone your fork locally.
2. Cd into the newly created ADAGE directory. 
3. Install the required version of Ruby. We recommend the use of the Ruby Version Manager (rvm) to keep track of your Ruby versions. If you do not have rvm installed you can find directions on installing it [here](https://rvm.io/rvm/install) or to quickly install rvm and rails try this:
	
	```\curl -L https://get.rvm.io | bash -s stable --rails```

	```rvm install ruby-1.9.3-p194```

4. Install MongoDB. On Mac it is easiest to use Homebrew
	
	```brew install mongodb```
	
5. Install Postgres. Again on a Mac use Hombrew

	```brew install postgresql```

6. Install Bundler
	
	```gem install bundler```

	If you encounter the invalid gemspec format error try:
	
	```gem update --system```
	
	Alternatively:
	
	```gem install rubygems-update```
	
	```update_rubygems```

7. Install libv8 
	
	```gem install libv8 -v '3.16.14.0'```

8. Install ruby racer 

	```gem install therubyracer```

9. Install the bundle 

	```bundle install```

###Install complete so take a break then come back for server setup!

1. Copy and update the contents of the following config templates

	```cp config/application.yml.template config/application.yml```
	
	```cp config/database.yml.template config/database.yml```
	
	```cp config/mongoid.yml.template config/mongoid.yml```
	
	```cp config/adjectives.txt.template config/adjectives.txt```
	
	```cp config/nouns.txt.template config/nouns.txt```
	
	```cp config/initializers/secret_token.rb.template config/initializers/secret_token.rb```
	
2. Create a secret token 

	```rake secret```
	
	```copy the token it generates and replace the CHANGE ME! text in config/initializers/secret_token.rb```
	
3. Create and set up the database 

	```rake db:setup```
4. Create the user abilities

	```rake abilities:create```
	

5. You should be done! Try running the server with ```rails server``` and see if it works. You may want to create an account and then use the ```rails console``` to locate your account and give it the admin ability.

	```me = User.where(player_name: "Insert the name you registered as here").first```
	
	```admin_role = Role.where(name: "admin").first```
	
	```me.roles << admin_role```



