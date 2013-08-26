require "locationary/version"
require "msgpack"
require "snappy"

module Locationary

  def Locationary.find(query)
    Locationary.data[query]
  end

  def Locationary.data
    @data ||= Locationary.load_data
  end

  private

  def Locationary.load_data
    raw = File.read("#{File.dirname(__FILE__)}/../db/geonames.bin")
    @data = MessagePack.unpack(Snappy.inflate(raw))
  end
end
