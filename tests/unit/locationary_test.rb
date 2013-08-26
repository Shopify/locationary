require "./tests/test_helper"
require "./lib/locationary"

class LocationaryTests < MiniTest::Unit::TestCase
  def test_locationary_responds_to_find
    assert Locationary.methods.include?(:find)
  end

  def test_locationary_does_load_data
    assert Locationary.data.any?
  end
end
