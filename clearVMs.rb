#! /usr/bin/ruby
require 'json'
require 'libvirt'

class Virt_Ops
  def initialize
      # HACK remove this for remote support
      # FIXME: put this in json file, for conf.
      virt_uri = 'qemu:///system'
      @@conn = Libvirt::open(virt_uri)

      @@active_dom = Array.new
      @@inactive_dom = Array.new
      # get actives domains
      @@conn.list_domains.each do |domid| 
        dom = @@conn.lookup_domain_by_id(domid)
          @@active_dom.push(dom.name)
        end
      # get inactive domains
      @@conn.list_defined_domains.each do |domname|
        @@inactive_dom.push(domname)
      end
  end
  def active_dom
    @@active_dom
  end
  def inactive_dom
    @@inactive_dom
  end

end

class Sumaform
  def initialize
     # this are machine without prefix, only suma3pg etc
     @@vm_names = Hash.new
     # this contains prod names, with prefix
     @@prod_vm_names = Hash.new
     #FIXME: REMOVE DMA prefix, only for testing
     @@prefixes = ["dma-", "head-", "headref-", "rf", "ts"]
  end

  # function that take the machines from a json file and append it the prefixes
  def get_machines(json_vms)
     fd = File.read(File.new(json_vms))
     @@vm_names = JSON.parse(fd)
     # append the prefixes at begin of vms names.
     @@prefixes.each do |prefix|
       @@vm_names.each do |name, status|
         @@prod_vm_names[prefix + name] = "OFF"
       end
     end
  end
  ## check status of given hash of virt-machines
  def check_machines
    vops = Virt_Ops.new
    # 1 ) get all active but existing machines.
    vms_active = vops.active_dom
    vms_active.each do |vm|
       @@prod_vm_names.each do |key, value|
         @@prod_vm_names[vm] = "ON" if key == vm
       end
    end
  puts @@prod_vm_names
  end
  # this function perform destruct. undefine and clean-up of disks.
  def destroy
     #TODO
     puts "detrosy machines"
     puts "undefine domain"
     puts "remove disk of machines"
  end

end

ramrod = Sumaform.new
ramrod.get_machines("sumaform-vms.json")
ramrod.check_machines
ramrod.destroy

# 1) use virsh for ruby bindings, in order to get machines from distance. system is only an HACK
