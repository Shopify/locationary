require "./tests/test_helper"
require "./lib/locationary"

class LookupTests < MiniTest::Unit::TestCase
  def setup
    # @kanata = {"Postal Code"=>"K2K2K1", "Latitude"=>"45.3261190000", "Longitude"=>"-75.9106530000", "City"=>"Kanata", "Province"=>"Ontario", "Country" => "Canada"}
    @address = {"zip"=>"90210", "province"=>"California", "city"=>"Beverly Hills"}
  end

  def test_strict_lookup_fails_quietly_on_wrong_data
    assert_equal nil, Locationary.find("foobar")
  end

  def test_strict_lookup_works_on_valid_data
    assert_equal @address, Locationary.find("90210")
  end

  def test_headers_correct
    louisville = Locationary.find("40202")
    assert_equal "Louisville", louisville['city']
    assert_equal "40202", louisville['zip']
    assert_equal "Kentucky", louisville['province']
  end

end