require "./tests/test_helper"
require "./lib/locationary"

class LookupTests < MiniTest::Unit::TestCase
  def setup
    # @kanata = {"Postal Code"=>"K2K2K1", "Latitude"=>"45.3261190000", "Longitude"=>"-75.9106530000", "City"=>"Kanata", "Province"=>"Ontario", "Country" => "Canada"}
    @address = {"Zip"=>"90210", "Province"=>"California", "City"=>"Beverly Hills", "Country" => "US"}
  end

  def test_strict_lookup_fails_quietly_on_wrong_data
    assert_equal nil, Locationary.find("foobar")
  end

  def test_strict_lookup_works_on_valid_data
    assert_equal @address, Locationary.find("90210")
  end

  def test_headers_correct
    louisville = Locationary.find("40202")
    assert_equal "Louisville", louisville['City']
    assert_equal "40202", louisville['Zip']
    assert_equal "US", louisville['Country']
    assert_equal "Kentucky", louisville['Province']
  end

end