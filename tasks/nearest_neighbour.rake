require 'kdtree'
require "./lib/locationary"

namespace :nearest_neighbour do
  desc 'persist nearest neighbour structure'
  task :create do
    build_time = Benchmark.measure do
      Locationary.persist_nn_structure
    end
    puts "nearest-neighbour tree built in #{build_time.real} seconds"
  end
end
