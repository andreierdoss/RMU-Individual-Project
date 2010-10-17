require 'rubygems'
require 'open-uri'
require 'octopi'
require 'database'

class Miner
  include Database
  include Octopi

  def initialize
    @coll = connect_db.collection("snapshots")
    mine_repos
  end
  
  def mine_repos
    Repository.find_all("ruby").each do |repo|
      begin
        populate_gems(repo.username, repo.name)
      rescue => e 
        puts e.inspect
      end
    end
  end

  def populate_gems user, repo
    gems = []
    gemfile_lock = "http://github.com/#{user}/#{repo}/raw/master/Gemfile.lock"
    open(gemfile_lock) do |f|
      f.each_line do |line|
        gems << {:name_version => extract_name_version(line)}
      end
      @coll.insert({:gems => gems})
    end
  end

  def extract_name_version line
    if line[/^\s{4}[a-zA-Z]/]
      gem_version = /(\()(.*?)(\))/.match(line)[2]
      gem_name = /(\s{4})(.*?)(\s)/.match(line)[2]
      [gem_name, gem_version].join("_")
    end
  end
end

Miner.new
