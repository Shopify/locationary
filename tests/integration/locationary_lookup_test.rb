require "./tests/test_helper"
require "./lib/locationary"

class LookupTests < MiniTest::Unit::TestCase
  def setup
    @kanata = {"Postal Code"=>"K2K2K1", "Latitude"=>"45.3261190000", "Longitude"=>"-75.9106530000", "City"=>"Kanata", "Province"=>"Ontario", "Country" => "Canada"}
  end

  def test_strict_lookup_fails_quietly_on_wrong_data
    assert_equal nil, Locationary.find("foobar",{:strict => true})
  end

  def test_strict_lookup_works_on_valid_data
    assert_equal @kanata, Locationary.find("K2K2K1",{:strict => true})
  end

  def test_postalcode_convenience_method
    assert_equal @kanata, Locationary.find_by_postalcode("K2K2K1", {:strict => true})
  end

  def test_postalcode_fuzzy_search
    assert_equal @kanata, Locationary.find_by_postalcode("K2K2Kl", {:strict => false})
  end

  def test_fuzzy_search_ignores_case
    assert_equal @kanata, Locationary.find_by_postalcode("k2k2K1", {:strict => false})
  end

  def test_fuzzy_search_finds_full_postal_code_despite_dyslexia
    assert_equal @kanata, Locationary.find_by_postalcode("j0hOP0", {:strict => false})
  end
end