#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'pp'
require 'time'
require 'date'
require 'mongo'
require 'csv'

MONGO_HOST = ENV["MONGO_HOST"]
raise(StandardError,"Set Mongo hostname in  ENV: 'MONGO_HOST'") if !MONGO_HOST
MONGO_PORT = ENV["MONGO_PORT"]
raise(StandardError,"Set Mongo port in  ENV: 'MONGO_PORT'") if !MONGO_PORT
MONGO_USER = ENV["MONGO_USER"]
#raise(StandardError,"Set Mongo user in  ENV: 'MONGO_USER'") if !MONGO_USER
#MONGO_PASSWORD = ENV["MONGO_PASSWORD"]
#raise(StandardError,"Set Mongo user in  ENV: 'MONGO_PASSWORD'") if !MONGO_PASSWORD

db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT.to_i).db("ccg")
# auth = db.authenticate(MONGO_USER, MONGO_PASSWORD)
# if !auth
#   raise(StandardError, "Couldn't authenticate, exiting")
#   exit
# end

hoursColl = db.collection("hours")
arr_of_arrs = CSV.read("sorted.ccg.csv")
arr_of_arrs.each do |a|
  first_name = a[0]
  last_name = a[1]
  hours = a.last.to_f
  $stderr.printf("%s,%s,%f\n", first_name, last_name, hours)
  existingPerson =  hoursColl.find_one({"first_name" => first_name, "last_name" => last_name})
  printf("first:%s last:%s not in database\n", first_name, last_name) if !existingPerson

  if existingPerson
    existingPerson["hours"] = hours
    hoursColl.update({"first_name" => first_name, "last_name" => last_name}, { "$set" => { "hours" => hours}})
  else
    hoursColl.insert({"first_name" => first_name, "last_name" => last_name, "hours"=> hours,
     "phone1" => "", "phone2" => "", "email" => "" })
  end
end
