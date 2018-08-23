#!/usr/bin/env ruby
require 'json'
require 'csv'

def transform(input)
  # convert input to proper csv format
  csv = CSV.parse(input,{encoding: "UTF-8",
                         headers: true,
                         header_converters: :symbol,
                         converters: :all})
  data = {apps: []}
  csv.map {|r| r.to_hash}.each do |row|
    props = {}
    props[:name] = row[:name]
    props[:servers] = row[:hosts].split(',').map {|h| {host_name: h.strip}}
    props[:datatbase_instances] = row[:dbs].split(',').map {|h| {name: h.strip}}
    props[:environment] = row[:env]
    data[:apps].push props
  end
  data
end

# Read data
data = STDIN.read

# Transform data
output = transform data

# Output data in pretty json format
puts JSON.pretty_generate(output)

# TODO do we need this?
# given a string will return true or false
def to_boolean(str)
  if %w/true yes/.include? str
    true
  else
    false
  end
end
