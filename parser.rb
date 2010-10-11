require 'rubygems'
require 'open-uri'

open("http://github.com/rsim/rails3_oracle_sample/raw/master/Gemfile.lock") do |f|
  f.each_line do |line|
    if line[/^\s{4}[a-zA-Z]/]
      p line
    end
  end
end
