require 'progressbar'
require 'json'
require 'csv'

class Student
  attr_accessor :user

  def initialize(user)
    self.user = user 
  end

  def dump_kode_sequence
    kode_logs = user.data.where(key: 'Kode')
    if kode_logs.count > 0
      kode_logs.each_with_index do |log, i|
        if log.respond_to?('kode')
          kode = log.kode['kode']
        else
          kode_string = log.data
          kode_string = '{'+kode_string+'}'
          kode_string = kode_string.strip
          start_say = kode_string.index('sayText')
          while start_say != nil
            end_say = kode_string.index('],', start_say)
            kode_string = kode_string[0..(start_say-2)] + kode_string[(end_say+2)..-1]
            start_say = kode_string.index('sayText')
          end
          start_say = kode_string.index('hearText')
          while start_say != nil
            end_say = kode_string.index('],', start_say)
            kode_string = kode_string[0..(start_say-2)] + kode_string[(end_say+2)..-1]
            start_say = kode_string.index('hearText')
          end

          kode_string = kode_string.gsub("'",'"')
          begin
            kode = JSON.parse(kode_string)['kode']
          rescue
            puts "WILL NOT PARSE"
            puts kode_string
            not_parsed = not_parsed + 1
          end
        end

        if kode != nil
          out = File.open('csv/kodu/kode_sequence/'+user.player_name+'_'+i.to_s, 'w')
          sensors = Array.new
          actions = Array.new

          kode['pages'].each do |page|
            page['lines'].each do |line|
              sensors << line['when']['sensor']
              actions << line['do']['action']
            end
          end

          puts sensors
          puts actions
          sensors.each do |s|
            out << s.to_s + ' '
          end
          actions.each do |a|
            out << a.to_s + ' '
          end
          out.close

        end


      end
    end

 
  
  end
  
  def run csv
    
    #find all the kode entries
    kode_logs = user.data.where(key: 'Kode')
    revision_count = Hash.new
    kode = nil
    not_parsed = 0
    flops = 0
    last_actor = nil
    last_level = nil
    if kode_logs.count > 0
      kode_logs.each do |log|
        if log.respond_to?('kode')
          kode = log.kode['kode']
        else
          kode_string = log.data
          kode_string = '{'+kode_string+'}'
          kode_string = kode_string.strip
          start_say = kode_string.index('sayText')
          while start_say != nil
            end_say = kode_string.index('],', start_say)
            kode_string = kode_string[0..(start_say-2)] + kode_string[(end_say+2)..-1]
            start_say = kode_string.index('sayText')
          end
          start_say = kode_string.index('hearText')
          while start_say != nil
            end_say = kode_string.index('],', start_say)
            kode_string = kode_string[0..(start_say-2)] + kode_string[(end_say+2)..-1]
            start_say = kode_string.index('hearText')
          end

          kode_string = kode_string.gsub("'",'"')
          begin
            kode = JSON.parse(kode_string)['kode']
          rescue
            puts "WILL NOT PARSE"
            puts kode_string
            not_parsed = not_parsed + 1
          end
        end

        if kode != nil
          actor = kode['actorName'] + kode['levelId']
          level = kode['levelId']
          #how many times have they switched back and forth between kodus while in one level
          if last_actor != nil
           if last_level == level
            if last_actor != actor 
            flops = flops + 1
            end
           end
          end
          last_actor = actor
          last_level = level
          if revision_count[actor] == nil
            revision_count[actor] = 0 
          else
            revision_count[actor] = revision_count[actor] + 1
          end
          sensors = Array.new
          actions = Array.new
          dowhen = Array.new
          kode['pages'].each do |page|
            page['lines'].each do |line|
              sensors << line['when']['sensor']
              actions << line['do']['action']
              dowhen << [line['when']['sensor'], line['do']['action']]
            end
          end
          csv << [user.player_name, log.schema, 
                  Time.at(log.timestamp.gsub(/[^0-9]/, '')[0..-4].to_i), 
                  kode['levelId'], actor, 
                  revision_count[actor], 
                  kode['pages'].count, 
                  flops,
                  sensors.count, 
                  sensors.uniq.count,
                  sensors.uniq.to_s,
                  actions.count, 
                  actions.uniq.count,
                  actions.uniq.to_s,
                  dowhen.to_s]
          
        end
      end

      #puts user.player_name + " successfully parsed!"
    end
    return not_parsed
  
  end

end

class AnalyizeKode

  def run name, students
    #bar = ProgressBar.new 'students', students.count
    csv = CSV.open("csv/kodu/"+name+".csv", "w") 
    csv << ['player name', 'schema', 
            'timestamp', 
            'Level Id', 
            'actor name', 
            'revision count', 
            'page count', 
            'actor switching',
            'sensor count', 
            'unique sensor count', 
            'sensors used', 
            'action count', 
            'unique action count', 
            'actions used',
            'sensor action pairs']
    total_lost = 0
    students.each do |student_name|
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      if user != nil
        not_parsed = Student.new(user).run csv
        total_lost = total_lost + not_parsed
      else
        puts student_name.first + " NOT FOUND"
      end
      #bar.inc
    end
    puts total_lost.to_s + " entries did not parse"
    csv.close

  end

  def dump_kode_sequence students
    students.each do |student_name|
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      if user != nil
        Student.new(user).dump_kode_sequence
      end
    end
  end

end

sparta = CSV.open("csv/kodu/sections/sparta.csv", 'r')
peagle = CSV.open("csv/kodu/sections/peagle.csv", 'r')
glacialD = CSV.open("csv/kodu/sections/glacialD.csv", 'r')
waunakee = CSV.open("csv/kodu/sections/waunakee.csv", 'r')
#AnalyizeKode.new.run 'Sparta_kode_parsed', sparta
#AnalyizeKode.new.run 'palmyra-eagle_kode_parsed', peagle
#AnalyizeKode.new.run 'glacial_drummlin_kode_parsed', glacialD
#AnalyizeKode.new.run 'waunakee_kode_parsed', waunakee 
AnalyizeKode.new.dump_kode_sequence sparta 
AnalyizeKode.new.dump_kode_sequence peagle
AnalyizeKode.new.dump_kode_sequence glacialD
AnalyizeKode.new.dump_kode_sequence waunakee
