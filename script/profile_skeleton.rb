result = RubyProf.profile do
  FlythroughStatistics.new.run
end

file = File.open("graph.html", "w")
printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(file)

file = File.open("stack.html", "w")
printer = RubyProf::CallStackPrinter.new(result)
printer.print(file)

file = File.open("stack.kcachegrind", "w")
printer = RubyProf::CallTreePrinter.new(result)
printer.print(file)
