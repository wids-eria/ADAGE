require 'json'
require 'csv'

class Student
  attr_accessor :user

  def initialize(user)
    self.user = user 
  end
  
  def run csv
    
    #find all the kode entries
    kode_logs = user.data.where(gameName: 'kodu')
    if kode_logs.count > 0
      #puts user.player_name + " has " + kode_logs.count.to_s + " kode logs" 
      #parse the kode to json
      kodes = Array.new
      kode_logs.each do |log|
        csv << [user.player_name, log.timestamp]
      end

      #puts user.player_name + " successfully parsed!"
    end
  
  end

end

class AnalyizeKode

  def run name, students
    #bar = ProgressBar.new 'students', students.count
    csv = CSV.open("csv/kodu/"+name+".csv", "w") 
    students.each do |student_name|
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      if user != nil
        Student.new(user).run csv
      else
        puts student_name.first + " NOT FOUND"
      end
      #bar.inc
    end
    csv.close

  end


end

sparta = CSV.open("csv/kodu/players.csv", 'r')
AnalyizeKode.new.run 'kodu_timestamp_dump', sparta
