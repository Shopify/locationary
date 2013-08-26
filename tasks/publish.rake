desc 'publish this gem to rubygems'
task :publish do
  system("gem build locationary.gemspec")
  system("gem push locationary-#{Locationary::VERSION}.gem")
end