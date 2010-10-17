require 'rubygems'
require 'sinatra'
require 'haml'
require 'database'

class Snapshot
  include Database
  
  def self.search query
    map = "function() {this.gems.forEach(function(z) { emit(z, {count : 1});});};"
    reduce = "function(key, values){var total=0; for(var i =0; i< values.length; i++) {total += values[i].count;}; return {count:total};};"
    connect_db.collection("snapshots").map_reduce(map,reduce,{ 
      :query => {"gems.name_version" => /^#{query}/}}).find().sort("value.count", -1)
  end
end

get '/' do
  haml :index
end

post '/' do
  @q = params[:q]
  @results = Snapshot.search(@q) unless @q == ""
  haml :index
end
