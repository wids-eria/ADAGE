namespace :clients do 
  desc 'safely create clients for all existing implementations'
  task :create => :environment do 
    Implementation.all.each do |version|
      if version.client.nil?
        puts 'creating client credentials for version ' + version.name
        Client.new(name: version.name, implementation: version)
      end  
    end 
  end
end
