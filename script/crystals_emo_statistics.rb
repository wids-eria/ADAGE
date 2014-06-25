require 'csv'

class Tplayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def init_hash keys
      hash = Hash.new
      keys.each do |k|
        hash[k] = 0.0
      end
      return hash

  end

  def run emo_csv, emo_list, choice_csv, cal_csv, con_csv


    choice_total = 0.0
    choice_success = 0.0
    choice_fail = 0.0
    choice_rt = 0.0
    choice_rt_success = 0.0
    choice_rt_fail = 0.0

    choice_emo_total = init_hash(emo_list) 
    choice_emo_success = init_hash(emo_list) 
    choice_emo_fail = init_hash(emo_list) 

    choice_first_success = 0.0

    cal_total = 0.0
    cal_success = 0.0
    cal_fail = 0.0
    
    cal_emo_total = init_hash(emo_list) 
    cal_emo_success = init_hash(emo_list) 
    cal_emo_fail = init_hash(emo_list) 
    
    cal_first_success = 0.0

    con_total = 0.0
    con_weight = init_hash([-1.0, 0.0, 1.0])
    con_rt = 0.0
    con_rt_weight = init_hash([-1.0, 0.0, 1.0]) 
    
    
    emo_first_try = true
    cal_first_try = false
    last_cal_emo = ''
    last_key = ''
    current_emo = ''    
    last_log = nil
    last_emo = ''
    last_token = ''



    puts user.player_name

    foo = user.data('KrystalsOfKaydor').count
    if foo == 0
      return
    end


    logs = user.data('KrystalsOfKaydor').without([:_id, :created_at, :updated_at]).asc(:timestamp)

    puts logs.count
    puts logs.first.inspect
   
    logs.each do |log|

      if last_log.nil? or last_log.attributes != log.attributes

        
        
        if log.key.include?('KoKEmotionChoice')
          current_emo = log.correct_answer

          answer_time = log.time_to_answer
          if log.time_to_answer > 30.0
            answer_time = 30.0
          end

          emo_first_try = true 
          
          choice_total += 1.0
          choice_rt += answer_time 
          choice_emo_total[current_emo] += 1.0
          if current_emo == log.player_answer
            choice_success += 1.0
            choice_emo_success[current_emo] += 1.0
            choice_rt_success = answer_time
            if last_key == log.key and last_emo == current_emo
              emo_first_try = false
            end 
            if emo_first_try 
              choice_first_success += 1.0
            end
          else
            emo_first_try = false
            choice_fail += 1.0
            choice_emo_fail[current_emo] += 1.0
            choice_rt_fail = answer_time
          end
          
          choice_csv << [user.player_name, emo_first_try] + log.attributes.values

          last_emo = current_emo 
        end

        if log.key.include?('KoKEmotionCalibration')

          cal_first_try = true
          cal_total += 1.0
          cal_emo_total[current_emo] += 1.0
          if log.success
            cal_success += 1.0
            cal_emo_success[current_emo] += 1.0
            if last_key == log.key and last_cal_emo == current_emo
              cal_first_try = false
            end


            if cal_first_try 
              cal_first_success += 1.0
            end

          else
            cal_first_try = false
            cal_fail += 1.0
            cal_emo_fail[current_emo] += 1.0
          end

          cal_csv << [user.player_name, cal_first_try] + log.attributes.values
          last_cal_emo = current_emo

        end

        if log.key.include?('KoKConversationChoice')


          con_csv << [user.player_name] + log.attributes.values

          con_total += 1.0
          con_rt += log.time_to_answer
          con_weight[log.answer_weight] += 1.0
          con_rt_weight[log.answer_weight] += log.time_to_answer



        end

        last_key = log.key
        last_log = log
      end



    end 

        
    emo_csv << [user.player_name, choice_total, choice_success, choice_fail, choice_first_success, choice_rt/choice_total, choice_rt_success/choice_success, choice_rt_fail/choice_fail] + 
      choice_emo_total.values + choice_emo_success.values + choice_emo_fail.values + 
      [cal_total, cal_success, cal_fail, cal_first_success] + 
      cal_emo_total.values + cal_emo_success.values + cal_emo_fail.values +  
      [ con_total, con_weight[ 1.0 ], con_weight[ 0.0 ], con_weight[ -1.0 ], con_rt/con_total, con_rt_weight[ 1.0 ]/con_weight[ 1.0 ], con_rt_weight[ 0.0 ]/con_weight[ 0.0 ], con_rt_weight[ -1.0 ]/con_weight[ -1.0 ]]
  








  end

end


class TenacityPlayerStats

  def run player_list
    emo_csv = CSV.open("csv/tenacity/crystals_emo_totals.csv", "w")
    choice_csv = CSV.open("csv/tenacity/crystals_choices.csv", "w")
    cal_csv = CSV.open("csv/tenacity/crystals_calibrations.csv", "w")
    con_csv = CSV.open("csv/tenacity/crystals_conversations.csv", "w")

    emo_list = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKEmotionChoice').distinct(:correct_answer)

    choice_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKEmotionChoice', schema: 'PRODUCTION-05-29-2013').without([:_id, :created_at, :updated_at]).asc(:timestamp).last
    cal_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKEmotionCalibration', schema: 'PRODUCTION-05-29-2013').without([:_id, :created_at, :updated_at]).asc(:timestamp).last
    con_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKConversationChoice', schema: 'PRODUCTION-05-29-2013').without([:_id, :created_at, :updated_at]).asc(:timestamp).last

    choice_csv << ['player name', 'first try'] + choice_log.attributes.keys
    cal_csv << ['player name', 'first try'] + cal_log.attributes.keys
    con_csv << ['player name'] + con_log.attributes.keys

    choice_emo = emo_list.map{ |e| e + ' choice count'}
    choice_emo_success = emo_list.map{ |e| e + ' choice success count'}
    choice_emo_fail = emo_list.map{ |e| e + ' choice fail count'}

    calibration_emo = emo_list.map{ |e| e + ' calibration count'}
    calibration_emo_success = emo_list.map{ |e| e + ' calibration success count'}
    calibration_emo_fail = emo_list.map{ |e| e + ' calibration fail count'}


    emo_csv << ['player name', 'choice count', 'choice success count', 'choice fail count', 'choice first try count', 'choice average response time', 'choice average response time success', 'choice average response time fail'] + 
      choice_emo + choice_emo_success + choice_emo_fail + 
      ['calibration count', 'calibration success count', 'calibration fail count', 'calibration first try count'] + 
      calibration_emo + calibration_emo_success + calibration_emo_fail +  
      ['conversation count', 'Ideal count', 'Neutral count', 'Negative count', 'conversation average response time', 'Ideal average response time', 'Neutral average response time', 'negative average response time'] 

    player_list.each do |player_name|
      player = User.where(player_name: player_name).first
      if player != nil
        Tplayer.new(player).run emo_csv, emo_list, choice_csv, cal_csv, con_csv
      else
        puts player_name.to_s + " NOT FOUND"
      end
    end
  end

end

#players = CSV.open("csv/tenacity/crystals_players.csv", 'r')
players = User.player_name_matches('5-0-')
players = players.map{ |u| u.player_name}
puts players.inspect
TenacityPlayerStats.new.run players
