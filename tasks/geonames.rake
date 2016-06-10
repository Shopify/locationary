require 'msgpack'
require 'net/http'
require 'csv'
require 'zip'
require 'snappy'
require 'benchmark'

namespace :geonames do
  desc 'create database'
  task :create do
    db_path = "./db/geonames.bin"
    zipdatafile = "./tmp/allCountries.zip"
    rawdata = "./tmp/allCountries.txt"
    data_headers = ["country","zip","city","province","province shortcode","place","city shortcode","region","region shortcode","latitude","longitude","accuracy"]

    result_headers = ["zip", "city", "province"]

    if File.exist?(db_path)
      File.delete(db_path)
    end

    begin
      download_time = Benchmark.measure do
        Net::HTTP.start("download.geonames.org") do |http|
          resp = http.get("/export/zip/allCountries.zip")
          open(zipdatafile, "wb") do |file|
            file.write(resp.body)
          end
        end
      end
      puts "downloaded file in #{download_time.real} seconds"
    end

    addresses = {}

    parse_time = Benchmark.measure do
      Zip::File.open(zipdatafile) do |archive|
        archive.each do |file|
          FileUtils.mkdir_p(File.dirname(rawdata))

          unless File.exist?(rawdata)
            open(rawdata, 'wb') do |f|
              f << file.get_input_stream.read
            end
          end

          data = File.read(rawdata)

          data.gsub!('"','')
          data.gsub!('\'','')

          CSV.parse(data, {:col_sep => "\t", :headers=>data_headers, :force_quotes => true}).each do |row|
            next unless "US" == row["country"]

            addresses[row["zip"].upcase] = row.to_hash.select {|k,v| result_headers.include?(k) }
          end
        end
      end

      puts " #{addresses.keys.count} addresses loaded from geonames"
    end
    puts "parsed data into address structure in #{parse_time.real} seconds"

    compress_time = Benchmark.measure do
      File.open(db_path,"w") do |file|
        file.write(Snappy.deflate(addresses.to_msgpack))
      end
    end
    puts "compressed and written data store to disk in #{compress_time.real} seconds"
  end

  desc 'statistics'
  task :stats do
    db = Locationary.data
    results = {:country => {}}

    db.values.each do |location|
      results[:country][location[:Country]] += 1
    end

    puts results.inspect
  end
end
