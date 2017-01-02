#! /usr/bin/ruby
require 'json'

class Virt_Sumaform
  def initialize()
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
    # HACK: Remove this local-cmd with real libivrt bindings.
    vms_active = `virsh list --name`.chomp.split
    vms_active.each do |vm|
       @@prod_vm_names.each do |key, value|
         @@prod_vm_names[vm] = "ON" if key == vm
       end
    end
  end
  # this function perform destruct. undefine and clean-up of disks.
  def destroy
     puts "detrosy machines"
     puts "undefine domain"
     puts "remove disk of machines"
  end

end

ramrod = Virt_Sumaform.new
ramrod.get_machines("sumaform-vms.json")
ramrod.check_machines

# TODO
# 1) use virsh for ruby bindings, in order to get machines from distance. system is only an HACK
