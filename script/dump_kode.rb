#require 'progressbar'
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
        csv << [user.player_name] + log.attributes.values
      end

      #puts user.player_name + " successfully parsed!"
    end

  end

end

class AnalyizeKode

  def run name, students
    #bar = ProgressBar.new 'students', students.count
    csv = CSV.open("script/csv/kodu/"+name+".csv", "w")
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

sparta = CSV.open("script/csv/kodu/sections/sparta.csv", 'r')
peagle = CSV.open("script/csv/kodu/sections/peagle.csv", 'r')
glacialD = CSV.open("script/csv/kodu/sections/glacialD.csv", 'r')
waunakee = CSV.open("script/csv/kodu/sections/waunakee.csv", 'r')
AnalyizeKode.new.run 'Sparta_kode_dump', sparta
AnalyizeKode.new.run 'palmyra-eagle_kode_dump', peagle
AnalyizeKode.new.run 'glacial_drummlin_kode_dump', glacialD
AnalyizeKode.new.run 'waunakee_kode_dump', waunakee
