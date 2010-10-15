require 'rubygems'
require 'open-uri'
require 'mongo'
require 'octopi'

include Octopi

db = Mongo::Connection.new.db("gemadvisor")
db.drop_collection("snapshots")
coll = db.collection("snapshots")
gems = Array.new
repos = Repository.find_all("ruby")

repos.each do |repo|
	gemfile_lock = "http://github.com/#{repo.username}/#{repo.name}/raw/master/Gemfile.lock"
	begin
		open(gemfile_lock) do |f|
			puts "scanning file: #{gemfile_lock}"
	
			f.each_line do |line|
				if line[/^\s{4}[a-zA-Z]/]
					gem_version = /(\()(.*?)(\))/.match(line)[2]
					gem_name = /(\s{4})(.*?)(\s)/.match(line)[2]
				  gems << {:name_version => gem_name + "_" + gem_version}
				end
			end
			coll.insert({"gems" => gems})
		end
	rescue
		puts "file not found: #{gemfile_lock}"
	end
end
