require 'json'
require 'csv'
require 'pathname'

class Student
  attr_accessor :user, :section_name

  def initialize(user, name)
    self.user = user 
    self.section_name = name
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

     log_file = File.open('csv/kodu/log.txt', 'a') 

    
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
          if log.kode != nil
            kode = log.kode['kode']
          end
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
            log_file << user.player_name + " " + section_name + " WILL NOT PARSE " + log.schema.to_s +   "\n"
            log_file << "*"*10 + "\n"
            puts "WILL NOT PARSE " + log.schema.to_s +   "\n"
            not_parsed = not_parsed + 1

            #page_start = kode_string.index('pages')
            #page_end = kode_string.index(':', page_start)
            #kode_string = kode_string[0..page_end] + '[' + kode_string[page_end+1..-1]
            #page_start = kode_string.index('pageNumber')
            #page_end = kode_string.index(':', page_start)
            #page_start = kode_string.index('pageNumber',page_end)
            #while page_start != nil
            #  kode_string = kode_string[0..page_start-2] + '},{' + kode_string[page_start-1..-1]
            #  page_end = kode_string.index(':', page_start)
            #  page_start = kode_string.index('pageNumber', page_end)
            #end
            #kode_string = kode_string[0..-3] + ']' + kode_string[-3..-1]

            #begin
            #  kode = JSON.parse(kode_string)['kode']
            #rescue
            #  puts "STILL WILL NOT PARSE"
            #  puts kode_string
            #end

          end
        end


        if kode != nil && kode['levelId'] != nil
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
                  log.timestamp.gsub(/[^0-9]/, '')[0..-4].to_i.to_s, 
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
    
    log_file = File.open('csv/kodu/'+name+'_not_found.txt', 'w') 
    csv = CSV.open("csv/kodu/"+name+".csv", "w") 
    csv << ['player name', 'schema', 
            'Epoch Time',
            'Human Time', 
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
      puts "looking for player " + student_name.first
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      #this is stupid
      if user == nil
        temp_name = student_name.first + " "
        user = User.where(["lower(player_name) = :login", login: temp_name]).first
      end
      if user != nil
        not_parsed = Student.new(user, name).run csv
        total_lost = total_lost + not_parsed
      else
        log_file << name + " : " + student_name.first + " NOT FOUND\n"
      end
    end
    log_file << total_lost.to_s + " entries did not parse"
    csv.close
    log_file.close

  end

  def dump_kode_sequence students
    students.each do |student_name|
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first
      if user != nil
        puts "dump sequence for " + student_name
        Student.new(user).dump_kode_sequence
      end
    end
  end

end

a_kode = AnalyizeKode.new
Dir.glob('./csv/kodu/sections/*.csv') do |section_file|
  puts section_file
  name = Pathname.new(section_file).basename.to_s
  file = CSV.open(section_file, 'r')
  a_kode.run "parsed_"+name, file 
  #a_kode.dump_kode_sequence file
end
