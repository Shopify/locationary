require "kdtree"

module Locationary

  def Locationary.nn_data
    @kd ||= Locationary.load_nn_data
  end

  def Locationary.clear_nn_data
    @kd = nil
    @kd_lookup = nil
  end

  def Locationary.nn_lookup
    @kd_lookup ||= Locationary.load_nn_lookup
  end

  def Locationary.nearest_neighbour(latitude, longitude, options = {})
    num_matches = options[:num_matches] ||= 1

    results = []
    Locationary.nn_data.nearestk(latitude, longitude, num_matches).each do |match|
      results << Locationary.data[Locationary.nn_lookup[match]]
    end
    results
  end

  def Locationary.persist_nn_structure
    points = []
    lookup = []
    i = 0

    Locationary.data.each do |location|
      lat = location[1]['Latitude']
      lon = location[1]['Longitude']
      if !lat.nil? and !lon.nil?
        points << [Float(location[1]['Latitude']), Float(location[1]['Longitude']), i]
        lookup << location[0]
        i += 1
      end
    end
    kd = Kdtree.new(points)

    File.open(Locationary.nn_data_location,"w") do |file|
      kd.persist(file)
    end

    File.open(Locationary.nn_lookup_location, "w") do |file|
      lookup.each { |l| file.write("#{l}\n") }
    end
  end

  private

  def Locationary.load_nn_lookup
    lookup = []
    Locationary.validate_nn_presence

    File.open(Locationary.nn_lookup_location) do |f|
      f.each { |l| lookup << l.strip }
    end
    lookup
  end

  def Locationary.load_nn_data
    Locationary.validate_nn_presence
    kd = File.open(Locationary.nn_data_location) { |f| Kdtree.new(f) }
  end

  def Locationary.validate_nn_presence
    if !File.exists?(Locationary.nn_lookup_location) or !File.exists?(Locationary.nn_data_location) then 
      Locationary.persist_nn_structure
    end
  end

  def Locationary.nn_data_location
    "#{Dir.pwd}/db/kdtree.bin"
  end

  def Locationary.nn_lookup_location
    "#{Dir.pwd}/db/lookup.txt"
  end

end
