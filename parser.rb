require 'rubygems'
require 'open-uri'
require 'mongo'
#require 'octopi'

#include Octopi

db = Mongo::Connection.new.db("gemadvisor")
#db.drop_collection("snapshots")
coll = db.collection("snapshots")
m = "function() {this.gems.forEach(function(z) { emit(z, {count : 1});});};"
r = "function(key, values){var total=0; for(var i =0; i< values.length; i++) {total += values[i].count;}; return {count:total};};"
res = coll.map_reduce(m,r,{ :query => {"gems.name" => /^active/}})
res.find().sort("value.count", -1).each { |row| puts row["_id"]["version"] }
#gems = Array.new
#repos = Repository.find_all("ruby")

#repos.each do |repo|
#	gemfile_lock = "http://github.com/#{repo.username}/#{repo.name}/raw/master/Gemfile.lock"
#	begin
#		open(gemfile_lock) do |f|
#			puts "scanning file: #{gemfile_lock}"
#			snapshot = {"snapshot" => 1}
#	
#			f.each_line do |line|
#				if line[/^\s{4}[a-zA-Z]/]
#					gem_version = /(\()(.*?)(\))/.match(line)[2]
#					gem_name = /(\s{4})(.*?)(\s)/.match(line)[2]
#				  gems << {:name => gem_name, :version => gem_version}
#				end
#			end
#			coll.insert(snapshot.merge({"gems" => gems}))
#		end
#	rescue
#		puts "file not found: #{gemfile_lock}"
#	end
#end
#puts coll.find({"gems.name" => /^cu/}).count #.each { |row| puts row.inspect }
#coll.find().each { |row| puts row.inspect }
