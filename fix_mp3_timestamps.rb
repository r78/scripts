#!/usr/bin/env ruby
# fix playing order of mp3 files in usb devices attached to stereo 
# systems which sort by date
require 'find'
require 'fileutils'

#working directory
fp_dir = ARGV[0]
fp_tmp = "#{ARGV[0]}/tmp"

puts "error: arg missing (directory)" unless fp_dir 
exit 1 unless fp_dir 
puts "error: invalid arg (not a directory)" unless File.directory? fp_dir
exit 2 unless File.directory? fp_dir

FileUtils.mkdir(fp_tmp)

Find.find fp_dir do |file|
  #do not recursively enter subdirectories
  Find.prune if File.directory?(file) and file != fp_dir
  if File.file?(file) #and File.extname(file) =~ /mp3/i
    #move it to the tmp directory
    `mv "#{file}" "#{fp_tmp}"`
  end
end

Find.find fp_tmp do |file_tmp|
  #do not recursively enter subdirectories
  Find.prune if File.directory?(file_tmp) and file_tmp != fp_tmp
  if File.file?(file_tmp) #and File.extname(file) =~ /mp3/i
    #move it to the original directory
    `mv "#{file_tmp}" "#{fp_dir}"`
  end
end

FileUtils.rm_r(fp_tmp)
