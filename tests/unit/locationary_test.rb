require "./tests/test_helper"
require "./lib/locationary"

class LocationaryTests < MiniTest::Unit::TestCase
  def test_locationary_responds_to_find
    assert Locationary.methods.include?(:find)
  end

  def test_locationary_does_load_data
    assert Locationary.data.any?
  end

  def test_locationary_respondsto_find_by_methods
    props = [:postalcode, :country_code, :state, :province, :community]
    props.each { |prop| assert Locationary.methods.include?("find_by_#{prop}".to_sym) }
  end
end
