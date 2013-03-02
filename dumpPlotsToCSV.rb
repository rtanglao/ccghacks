#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'pp'
require 'time'
require 'date'
require 'mongo'
require 'fastercsv'

MONGO_HOST = ENV["MONGO_HOST"]
raise(StandardError,"Set Mongo hostname in  ENV: 'MONGO_HOST'") if !MONGO_HOST
MONGO_PORT = ENV["MONGO_PORT"]
raise(StandardError,"Set Mongo port in  ENV: 'MONGO_PORT'") if !MONGO_PORT
MONGO_USER = ENV["MONGO_USER"]
#raise(StandardError,"Set Mongo user in  ENV: 'MONGO_USER'") if !MONGO_USER
#MONGO_PASSWORD = ENV["MONGO_PASSWORD"]
#raise(StandardError,"Set Mongo user in  ENV: 'MONGO_PASSWORD'") if !MONGO_PASSWORD

db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT.to_i).db("ccg")

plotsColl = db.collection("plots")
plots = plotsColl.find({}).each do |p| 
  if p["plot"].length > 2
    printf("%s,%s,%s\n",p["plot"], p["last"], p["first"])
  else
    plot_str=p["plot"][0,1]+"0"+p["plot"][1,1]
    printf("%s,%s,%s\n",plot_str, p["last"], p["first"])
  end
end

