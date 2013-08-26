require "./tests/test_helper"

class NearestNeighbourLookupTests < MiniTest::Unit::TestCase
  def test_finds_single_nearest_neighbour
    actual = "P6C3T9"
    assert_equal Locationary.nearest_neighbour(46.5333, -84.35)[0]["Postal Code"], actual
  end

  def test_finds_multiple_nearest_neighbours
    actual = ["K2P1J2", "K2P0C2", "K2P0B9"]

    results = Locationary.nearest_neighbour(45.4208, -75.69, num_matches: 3)
    assert_equal results.length, 3
    assert_equal results[0]["Postal Code"], actual[0]
    assert_equal results[1]["Postal Code"], actual[1]
    assert_equal results[2]["Postal Code"], actual[2]
  end

  def test_persists_nn_data_if_empty
    Locationary.clear_nn_data

    actual = "K2P1J2"
    results = Locationary.nearest_neighbour(45.4208, -75.69)
    assert_equal results[0]["Postal Code"], actual
  end
end
