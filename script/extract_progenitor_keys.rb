require 'set'

keys = Set.new

User.where(:consented => true).each do |user|
  user.progenitor_data.each do |datum|
    keys.add datum.key.to_sym
    #print "."
  end
end

puts ""
puts keys.to_a.inspect
