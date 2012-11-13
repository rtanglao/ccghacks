#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'pp'
require 'time'
require 'date'
require 'mongo'
require 'csv'

arr_of_arrs = CSV.read("sorted.ccg.csv")
arr_of_arrs.each do |a|
  printf("%s,%s,%s\n", a[0], a[1], a.last)
end
