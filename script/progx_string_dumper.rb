Log_Symbols = ['.', :MissionActionData, :PopulateGridData, :GridStateData, :DialogButtonData, :InventorySelectedData, :ToolSelectedData, :ToolUseData, :CellCollectionData, :ObjectiveActionData, :ViewSelectedData, :TissueCollectionData, :GridDestroyData, :AlmanacView]
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
    output_as_symbols << datum.key.to_sym
  end
  puts "#{user.id}: #{singlify_string Log_Symbols, output_as_symbols}"
end
