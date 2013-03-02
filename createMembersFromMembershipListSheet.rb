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
# auth = db.authenticate(MONGO_USER, MONGO_PASSWORD)
# if !auth
#   raise(StandardError, "Couldn't authenticate, exiting")
#   exit
# end

# hoursColl = db.collection("hours")
printf("Last Name, First Name, Phone Number, Email, Fees Paid in current year, Date Fees last paid, Sharing with\n")
arr_of_arrs = FasterCSV.read("membership.list.csv")

arr_of_arrs.each do |a|
  first_name = a[0]
  last_name = a[1]
  email = a[2]
  phone1= a[3]
  phone2 = a[4]
  member_status = a[5]
  date_joined = a[6]
  latest_renewal = a[7]
  amt_paid = a[8]
  plot_counts = a[9]
  member_counts = a[10]
  plot_number = a[11]
  sharing_with = a[12]
#   $stderr.printf("1st:%s, last:%s,email:%s,phone1:%s,phone2:%s,member status:%s,date_joined:%s,latest_renewal:%s,\
# #paid:%s,\
# plot_counts:%d,member_counts:%d,plot_number:%s\n",
#   first_name,
#   last_name,
#   email,
#   phone1,
#   phone2,
#   member_status,
#   date_joined,
#   latest_renewal,
#   amt_paid,
#   plot_counts.to_i,
#   member_counts.to_i,
#   plot_number)
phone = phone1
if !phone2.nil?
  phone = phone1 + " ; " + phone2
end

date_joined = Time.parse(date_joined).utc
sep_1_2012 = Time.utc(2012,9,1)
dec_31_2012 = Time.utc(2012,12,31,23,59,59)
if ((date_joined <=> sep_1_2012) >= 0) &&
    ((date_joined <=> dec_31_2012) <= 0)
  date_fees_last_paid = "31-Dec-2012"
else
  date_fees_last_paid = "31-Dec-2011"
end

printf("%s,%s,%s,%s,%d,%s,%s\n", last_name, first_name, phone, email,0, date_fees_last_paid,sharing_with)


end
# if data joined >= September 1, 2012 and <= December 31, 2012 then they are considered to have paid for 2013
  # existingPerson =  hoursColl.find_one({"first_name" => first_name, "last_name" => last_name})
  # printf("first:%s last:%s not in database\n", first_name, last_name) if !existingPerson

  # if existingPerson
  #   existingPerson["hours"] = hours
  #   hoursColl.update({"first_name" => first_name, "last_name" => last_name}, { "$set" => { "hours" => hours}})
  # else
  #   hoursColl.insert({"first_name" => first_name, "last_name" => last_name, "hours"=> hours,
  #    "phone1" => "", "phone2" => "", "email" => "" })
  # end

