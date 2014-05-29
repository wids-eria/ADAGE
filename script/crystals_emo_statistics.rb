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
    
    
    first_try = true
    last_key = ''
    current_emo = ''    



    puts user.player_name


    logs = user.data('KrystalsOfKaydor').where(:key.in => ['KoKEmotionChoice', 'KoKEmotionCalibration', 'KoKConversationChoice']).asc(:timestamp)
   
    logs.each do |log|

      if last_key == log.key
        first_try = false
      end


      
      if log.key.include?('KoKEmotionChoice')
        current_emo = log.correct_answer

        choice_csv << [user.player_name, first_try] + log.attributes.values
        
        
        choice_total += 1.0
        choice_rt += log.time_to_answer
        choice_emo_total[current_emo] += 1.0
        if current_emo == log.player_answer
          choice_success += 1.0
          choice_emo_success[current_emo] += 1.0
          choice_rt_success = log.time_to_answer
          if first_try 
            choice_first_success += 1.0
          end
          first_try = true
        else
          choice_fail += 1.0
          choice_emo_fail[current_emo] += 1.0
          choice_rt_fail = log.time_to_answer
        end

        
      end

      if log.key.include?('KoKEmotionCalibration')
        
        cal_csv << [user.player_name, first_try] + log.attributes.values

        cal_total += 1.0
        cal_emo_total[current_emo] += 1.0
        if log.success
          cal_success += 1.0
          cal_emo_success[current_emo] += 1.0
          if first_try 
            cal_first_success += 1.0
          end
          first_try = true

        else
          cal_fail += 1.0
          cal_emo_fail[current_emo] += 1.0
        end


      end

      if log.key.include?('KoKConversationChoice')


        con_csv << [user.player_name] + log.attributes.values

        con_total += 1.0
        con_rt += log.time_to_answer
        con_weight[log.answer_weight] += 1.0
        con_rt_weight[log.answer_weight] += log.time_to_answer



      end

      last_key = log.key





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

    choice_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKEmotionChoice', schema: 'PRODUCTION-05-29-2013').asc(:timestamp).last
    cal_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKEmotionCalibration', schema: 'PRODUCTION-05-29-2013').asc(:timestamp).last
    con_log = AdaData.with_game('KrystalsOfKaydor').where(key: 'KoKConversationChoice', schema: 'PRODUCTION-05-29-2013').asc(:timestamp).last

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

players = CSV.open("csv/tenacity/crystals_players.csv", 'r')
TenacityPlayerStats.new.run players
