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
in_db = 0
out = 1
CSV.foreach("ccg-membership-database.csv") do |row|
  first_name = row[2]
  last_name = row[3]
  email = row[4]
  phone1 = row[5]
  phone2 = row[6]
  $stderr.printf("%s,%s,%s,%s,%s\n", first_name, last_name, email, phone1, phone2)
  existingPerson =  hoursColl.find_one({"first_name" => first_name, "last_name" => last_name})
  if !existingPerson
    $stderr.printf("first:%s last:%s not in database\n", first_name, last_name) 
    out += 1
  else
    $stderr.printf("first:%s last:%s IS IN database\n", first_name, last_name)
    in_db += 1
  end 
  if existingPerson
    hoursColl.update({"first_name" => first_name, "last_name" => last_name}, { "$set" => 
                       { "email" => email, "phone1" => phone1, "phone2"=> phone2 }})
  else
    hoursColl.insert({"first_name" => first_name, "last_name" => last_name, "hours" => 0.0,
                       "phone1" => phone1, "phone2" => phone2, "email" => email })
  end
end
$stderr.printf("in:%d out:%d\n", in_db, out)
printf ("first_name,last_name,hours,phone1,phone2,email\n")
hoursColl.find().each do |p|
  printf("%s,%s,%f,%s,%s,%s\n",p["first_name"], p["last_name"], p["hours"], p["phone1"], p["phone2"], p["email"])
end

