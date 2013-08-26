require "locationary/version"
require "msgpack"
require "snappy"
require "levenshtein"
require "xor"

module Locationary

  def Locationary.find(query, options = {:strict => true})
    query.upcase
    
    result = Locationary.data[query]
    #if the user asked for a fuzzy lookup and we didn't find an exact match above
    if not options[:strict] and not result
      result = Locationary.fuzzy(query)
    end

    result
  end

  def Locationary.fuzzy(query)
    best_score = 9999999999
    best_hamming = 9999999999
    best_match = nil
    Locationary.data.keys.each do |key|
      new_score = Levenshtein.distance(key,query)
      if new_score < best_score
        new_hamming = 0
        key.dup.xor!(query).bytes.each { |b| new_hamming += b}
        if new_hamming < best_hamming
          best_score = new_score
          best_match = key
        end
      end
    end

    Locationary.data[best_match]
  end

  def Locationary.data
    @data ||= Locationary.load_data
  end

  private

  def Locationary.load_data
    raw = File.read("#{File.dirname(__FILE__)}/../db/geonames.bin")
    @data = MessagePack.unpack(Snappy.inflate(raw))
  end

  PROPERTIES = {
    postalcode: "Postal Code",
    country_code: "Country Code",
    state: "Name 1",
    province: "Name 2",
    community: "Name 3"
  }

  PROPERTIES.each do |location_prop|
    class_eval <<-RUBY, __FILE__, __LINE__ +1
      def Locationary.find_by_#{location_prop[0].to_s}(val, options)
        Locationary.find(val, options)
      end
    RUBY
  end
end
