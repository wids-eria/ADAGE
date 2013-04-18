require 'progressbar'
require 'json'

class Student
  attr_accessor :user

  def initialize(user)
    self.user = user 
  end
  
  def run
    
    #find all the kode entries
    kode_logs = user.data.where(schema: '1.3.8.0', key: 'Kode')
    if kode_logs.count > 0
      puts user.player_name + " has " + kode_logs.count.to_s + " kode logs" 
      #parse the kode to json
      kodes = Array.new
      kode_logs.each do |log|
        kode_string = log.data
        kode_string = '{'+kode_string+'}'
        kode_json = JSON.parse(kode_string.gsub("'",'"'))
        kodes << kode_json
      end

      puts user.player_name + " successfully parsed!"
    end
  
  end

end

class AnalyizeKode

  def run
    students = User.select{|u| u.data.count > 0}
    #bar = ProgressBar.new 'students', students.count
    students.each do |user|
      Student.new(user).run
      #bar.inc
    end

  end


end

AnalyizeKode.new.run
