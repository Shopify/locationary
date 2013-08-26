require "./tests/test_helper"
require "./lib/locationary"
require "./lib/nn"
require "benchmark"

class NearestNeighbourPerformanceTests < MiniTest::Unit::TestCase
  def test_loading_nn_data_speed
    Locationary.clear_nn_data

    nn_loading_speed = Benchmark.measure do
      kd = Locationary.nn_data
      kd_lookup = Locationary.nn_lookup
    end
    assert nn_loading_speed.real < 1
  end

  def test_single_lookup_speed
    d = Locationary.data
    kd = Locationary.nn_data
    kd_data = Locationary.nn_lookup

    lookup_speed = Benchmark.measure do 
      result = Locationary.nearest_neighbour(34.1, -118.2)
    end
    
    assert lookup_speed.real < 0.01
  end

  def test_multiple_lookup_speed
    d = Locationary.data
    kd = Locationary.nn_data
    kd_data = Locationary.nn_lookup

    lookup_speed = Benchmark.measure do
      results = Locationary.nearest_neighbour(45.42083333333334, -75.69, num_matches: 3)
    end

    assert lookup_speed.real < 0.01
  end
end