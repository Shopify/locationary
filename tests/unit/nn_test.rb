require "./tests/test_helper"

class NearestNeighbourTests < MiniTest::Unit::TestCase

  def test_nn_responds_to_nearest_neighbour
    assert Locationary.methods.include?(:nearest_neighbour)
  end

  def test_nn_does_load_data
    assert !Locationary.nn_data.nil?
    assert Locationary.nn_lookup.any?
  end
end
