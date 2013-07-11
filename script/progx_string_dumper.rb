Log_Symbols = ['.', :MissionActionData, :PopulateGridData, :GridStateData, :DialogButtonData, :InventorySelectedData, :ToolSelectedData, :ToolUseData, :CellCollectionData, :ObjectiveActionData, :ViewSelectedData, :TissueCollectionData, :GridDestroyData, :AlmanacView]
Stop_Symbols = [:GridStateData]

Output_Alphabet = '.abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'
def singlify symbols, input
  index = Log_Symbols.index input
  if index
    Output_Alphabet[index]
  else
    input
  end
end

def singlify_string symbols, input
  (input.collect {|foo| singlify(symbols, foo)}).join
end

User.where(:consented => true).each do |user|
  output_as_symbols = []
  user.progenitor_data.each do |datum|
    output_as_symbols << datum.key.to_sym if !Stop_Symbols.include? datum.key.to_sym
  end
  File.open("script/dumped_strings/#{user.id}.txt", 'w') {|f| f.write(singlify_string Log_Symbols, output_as_symbols) }
  #puts "#{user.id}: #{singlify_string Log_Symbols, output_as_symbols}"
end
