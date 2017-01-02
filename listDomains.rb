#! /bin/usr/ruby

require 'libvirt'

VIRT_URI="qemu:///system"
conn = Libvirt::open(VIRT_URI)

# get the number of active (running) domains and list them; the full domain
# list is available through a combination of the list returned from
# conn.list_domains and the list returned from conn.list_defined_domains
puts "Connection number of active domains: #{conn.num_of_domains}"
puts "Connection active domains:"
conn.list_domains.each do |domid|
  dom = conn.lookup_domain_by_id(domid)
  puts " Domain #{dom.name}"
end

# get the number of inactive (shut off) domains and list them
puts "Connection number of inactive domains: #{conn.num_of_defined_domains}"
puts "Connection inactive domains:"
conn.list_defined_domains.each do |domname|
  puts " Domain #{domname}"
end

# after close, the closed? should return true
puts "After close, connection closed?: #{conn.closed?}"
conn.close
