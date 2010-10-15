require 'rubygems'
require 'sinatra'
require 'mongo'
require 'haml'

db = Mongo::Connection.new.db("gemadvisor")
coll = db.collection("snapshots")
m = "function() {this.gems.forEach(function(z) { emit(z, {count : 1});});};"
r = "function(key, values){var total=0; for(var i =0; i< values.length; i++) {total += values[i].count;}; return {count:total};};"

get '/' do
  haml :index
end

post '/' do
	@q = params[:q]
  @results = coll.map_reduce(m,r,{ :query => {"gems.name_version" => /^#{@q}/}}).find().sort("value.count", -1)
	haml :index
end
