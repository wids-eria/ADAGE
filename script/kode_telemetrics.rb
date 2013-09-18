
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

    log_file = File.open('script/csv/kodu/log.txt', 'a')

    #find all the kode entries
    kode_logs = user.data.where(key: 'Kode')

    kodes = Array.new
    #Reform the broken JSON and parse it into a mkode object
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
            #Add timestampe field to kode object for easier logging later
            kode = JSON.parse(kode_string)['kode']
            kode['timestamp'] = log.timestamp
            kodes << kode
          rescue
            log_file << user.player_name + " " + section_name + " WILL NOT PARSE " + log.schema.to_s +   "\n"
            log_file << "*"*10 + "\n"
            puts "WILL NOT PARSE " + log.schema.to_s +   "\n"
            not_parsed = not_parsed + 1
          end
        end
      end
    end

    temp = Array.new

    #Map all kode json objects to an array of unique IDS
    kodu_ids = kodes.map{|kode| kode['actorName']+kode['levelId']}.uniq

    #Group Kodu by unique level id and put it in temp
    kodu_ids.each do |id|
      kodes.each do |kode|
        if (kode['actorName']+kode['levelId']) == id
          temp << kode
        end
      end
    end
    kodes = temp

    revision_count = Hash.new
    kode = nil
    not_parsed = 0
    flops = 0
    last_actor = nil
    last_level = nil

    max_pages = 0
    max_page_length = 0
    max_indentation = 0
    max_kode_length = 0
    max_primitives = 0

    total_pages = 0
    total_indentation = 0
    total_kode_length = 0
    other_current_kodi = 0

    total_code = kode_logs.count

    sensors = Array.new
    actions = Array.new
    dowhen = Array.new

    last_kodu = nil
    kodes.each do |kode|
      if kode != nil && kode['levelId'] != nil
        actor = kode['actorName'] + kode['levelId']
        level = kode['levelId']

        if actor != last_kodu or last_kodu.nil?
          #if the current kode is not in the same group as the last, then log the data
          unless last_kodu.nil?
            csv << [user.player_name,
                    level,
                    kode['timestamp'].gsub(/[^0-9]/, '')[0..-4].to_i.to_s,
                    actor,
                    total_pages,
                    max_page_length,
                    (Float(total_kode_length)/total_pages).to_s,
                    other_current_kodi,
                    actions.uniq.count,
                    sensors.uniq.count,
                    total_kode_length,
                    max_indentation]
          end

          #reinit values for each unique group with same kodu ID
          last_kodu = actor
          total_kode_length = 0
          max_indentation = 0
          max_page_length = 0
          total_pages = 0
          total_indentation = 0
          other_current_kodi = 0

          sensors = Array.new
          actions = Array.new
          dowhen = Array.new
        else
          other_current_kodi += 1
          endgroup = false
        end

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

        num_pages = kode['pages'].length
        total_pages += num_pages
        if(max_pages<num_pages)
          max_pages = num_pages
        end

        kode['pages'].each do |page|
          page['lines'].each do |line|
            sensors << line['when']['sensor']
            actions << line['do']['action']
            dowhen << [line['when']['sensor'], line['do']['action']]

            if line.has_key?('indentation')
              #accumulate line stats
              indentation = line['indentation'].to_i
              total_indentation += indentation
              if max_indentation<indentation
                max_indentation = indentation
              end
            end
          end

          if max_page_length<page['lines'].length
            max_page_length = page['lines'].length
          end

          total_kode_length += page['lines'].length
        end

      end


    end

    return not_parsed
  end
end

class AnalyizeKode

  def run name, students
    log_file = File.open('script/csv/kodu/'+name+'_not_found.txt', 'w')
    csv = CSV.open("script/csv/kodu/"+name+".csv", "w")
    csv << ["username",
            "current_file",
            "timestamp",
            "current_kodu",
            "#pages",
            "max_page_length",
            "avg_page_length",
            "#other_current_kodi",
            "#distinct_action_primitives",
            "#distinct_sensor_primitives",
            "kode_length",
            "kode_depth"]

    total_lost = 0

    students.each do |student_name|
      puts "looking for player " + student_name.first
      user = User.where(["lower(player_name) = :login", login: student_name.first.downcase]).first

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

puts "Starting..."
a_kode = AnalyizeKode.new

puts Dir.pwd
Dir.glob('./script/csv/kodu/sections/*.csv') do |section_file|
  puts section_file
  name = Pathname.new(section_file).basename.to_s
  file = CSV.open(section_file, 'r')
  a_kode.run "parsed_"+name, file
  #a_kode.dump_kode_sequence file
  break
end

puts "Finished"