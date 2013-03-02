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

membersColl = db.collection("members")
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

  if !plot_number.nil?
    plot_array = plot_number.split(";")
    plot_array_2 = []
    plot_array.each do |p|
      plot_array_2.push(p.strip.upcase)
    end
    plot_number=plot_array_2.join(";")
  end
  printf("%s,%s,%s,%s,%d,%s,%s,plots:%s\n", last_name, first_name, phone, email,0, date_fees_last_paid,sharing_with, plot_number)

  member = {}
  member["last"] = last_name
  member["first"] = first_name
  member["phone"] = phone
  member["email"] = email
  member["fees_paid_in_current_year"] = 0.0
  member["date_fees_last_paid"] = date_fees_last_paid
  member["sharing_with"] = sharing_with

 membersColl.insert(member)

end

