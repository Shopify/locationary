require "locationary/version"
require "msgpack"
require "snappy"

module Locationary

  def self.find(query)
    data[query]
  end

  private

  def self.data
    @data ||= load_data
  end

  def self.load_data
    raw = File.read("#{File.dirname(__FILE__)}/../db/geonames.bin")
    MessagePack.unpack(Snappy.inflate(raw))
  end
end
