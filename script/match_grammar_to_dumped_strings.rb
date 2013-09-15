require 'narray'
require 'csv'

def match_string_to_regexes(string)
  matches = {}
  grammar_file = File.open("script/grammars.txt", "r")
  line_num = 0
  grammar_file.lines.each do |line|
    stripped = line.strip
    #puts "\ttrying #{line}"
    match_count = string.scan(stripped).size
    matches[line_num] = match_count if match_count>0
    line_num += 1
  end
  matches
end

def loop_over_all_the_files
  names_to_matches = {}
  Dir.glob("script/dumped_strings/*.txt").each do |filename|
    string = File.open(filename, mode = "r").read.strip
    next if string.length == 0
    matches = match_string_to_regexes(string)
    session_id = filename.match("/([0-9]+).txt")[1]
    names_to_matches[session_id] = matches if matches.count > 0
  end
  names_to_matches
end

def create_match_array(matches)
  width = File.open("script/grammars.txt", "r").lines.count
  height = Dir.glob("script/dumped_strings/*.txt").count
  match_array = NArray.int(width + 1, height)
  
  row = 0
  matches.keys.each do |key|
    match_array[0, row] = key.to_i #first column is the session id
    counts_for_session = matches[key]
    counts_for_session.keys.each do |col|
      match_array[col + 1, row] = counts_for_session[col]
    end 
    row += 1
  end
    
  match_array
end

all_the_matches = loop_over_all_the_files

big_array = create_match_array(all_the_matches)
CSV do |csv_out|
  grammar_file = File.open("script/grammars.txt", "r")
  header = ["session_id"]
  grammar_file.lines.each do |line|
    header << line.strip
  end
  
  csv_out << header
  
  big_array.shape[1].times do |row|
    csv_out << big_array[true, row].to_a
  end
end            