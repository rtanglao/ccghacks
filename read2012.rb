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

# hoursColl = db.collection("hours")
arr_of_arrs = CSV.read("ccg.garden.20feb2013.csv")
arr_of_arrs.each do |a|
  pp a
  first_name = a[0]
  last_name = a[1]
  email = a[2]
  phone1= a[3]
  phone2 = a[4]
  member_status = a[5]
  date_joined = a[6]
  latest_renewal = a[7]
  amt_paid = a[8]
  plot_counts = a[9].to_i
  member_counts = a[10].to_i
  plot_nummber = a[11]
  $stderr.printf("1st:%s,last:%s,email:phone1:%s,phone2:%s,member status:%s\
  ,date_joined:%s,latest_renewal:%s,amount paid:%s,plot_counts:%d,\
  member_counts:%d,plot_number%s%\n",\
  first_name,
  last_name,
  email,
  phone1,
  phone2,
  member_status,
  date_joined,
  latest_renewal,
  amt_paid,
  plot_counts,
  member_counts,
  plot_nummber)

  # existingPerson =  hoursColl.find_one({"first_name" => first_name, "last_name" => last_name})
  # printf("first:%s last:%s not in database\n", first_name, last_name) if !existingPerson

  # if existingPerson
  #   existingPerson["hours"] = hours
  #   hoursColl.update({"first_name" => first_name, "last_name" => last_name}, { "$set" => { "hours" => hours}})
  # else
  #   hoursColl.insert({"first_name" => first_name, "last_name" => last_name, "hours"=> hours,
  #    "phone1" => "", "phone2" => "", "email" => "" })
  # end
end
