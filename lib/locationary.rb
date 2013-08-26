require "locationary/version"
require "msgpack"
require "snappy"

module Locationary

  def Locationary.find(query)
    Locationary.data[query]
  end

  private

  def Locationary.data
    @data ||= Locationary.load_data
  end

  def Locationary.load_data
    raw = File.read("#{File.dirname(__FILE__)}/../db/geonames.bin")
    MessagePack.unpack(Snappy.inflate(raw))
  end
end
