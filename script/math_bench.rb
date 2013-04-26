require "benchmark"

Benchmark.bm(7) do |bench|
    bench.report("multiply:") { (1..100000000).each { x = rand; x * 2 } }
    bench.report("power:")    { (1..100000000).each { x = rand; x ** x } }
end
