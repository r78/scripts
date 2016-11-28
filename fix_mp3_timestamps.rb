#!/usr/bin/env ruby
# fix playing order of mp3 files in usb devices attached to stereo 
# systems which sort by date
require 'find'

#working directory
fp_dir = ARGV[0]

puts "error: arg missing (directory)" unless fp_dir 
exit 1 unless fp_dir 
puts "error: invalid arg (not a directory)" unless File.directory? fp_dir
exit 2 unless File.directory? fp_dir

t_mod = 0
ct_inc = 0

Find.find fp_dir do |file|
  #do not recursively enter subdirectories
  Find.prune if File.directory?(file) and file != fp_dir
  if File.file?(file) and File.extname(file) =~ /mp3/i
    #get the mtime of the first mp3 file
    t_mod = File.stat(file).mtime if t_mod == 0
    t_acc = File.stat(file).atime
    #set incremental mtimes for each mp3
    File.utime(t_acc, t_mod + ct_inc, file)
    ct_inc += 1
  end
end
