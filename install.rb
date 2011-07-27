# install.rb  Richard Kernahan <kernighan_rich@rubyforge.org>

require 'fileutils'

puts "Installation for Crypt :: pure-ruby cryptographic library"

print "  [ ] Looking for installation directory ... "
installationFolder = $:.find {|d| d =~ /lib.ruby.site_ruby.1.8$/}
installationFolder = $:.find {|d| d =~ /lib.ruby.1.8$/} unless installationFolder
installationFolder = $:[0] unless installationFolder
if installationFolder.nil?()
  print "failed\n  Sorry. Could not find a directory to install in.\n  It might be easier to use the rubygem.\n"
  exit 1
end
print "ok --> #{installationFolder} \n"

print "  [ ] checking that the directory is writable ... "
unless File.writable?(installationFolder)
  print "failed\n  It appears you do not have sufficient authority to install Crypt \n"
  print "  to the directory #{installationFolder}\n" 
  exit 2
end
print "ok\n"

cryptDir = installationFolder + "/crypt"
if File.exist?(cryptDir)
  print "  [ ] folder #{cryptDir} already exists.\n"
else
  print "  [ ] creating folder #{cryptDir} ... "
  begin
    Dir.mkdir(cryptDir)
  rescue SystemCallError
    print "failed.\n  Sorry. We were unable to create the directory.\n"
    exit 3
  end
  print "ok\n"
end

#gen filesToInstall()
filesToInstall = [
  'crypt/blowfish.rb',
  'crypt/blowfish-tables.rb',
  'crypt/cbc.rb',
  'crypt/gost.rb',
  'crypt/idea.rb',
  'crypt/noise.rb',
  'crypt/rijndael-tables.rb',
  'crypt/rijndael.rb',
  'crypt/stringxor.rb',
]
#endgen

begin
  puts "  [ ] installing files:"
  filesToInstall.each { |f| 
    FileUtils.install(f, cryptDir)
    puts "  ok  #{f}"
  }
rescue
  puts "  Sorry. Encountered a problem installing the files."
  exit 4
end

puts "\nCongratulations! The installation completed successfully."
puts "To use Blowfish, just add to your code:"
puts "  require 'crypt/blowfish'" 
puts "or a similar statement for one of the other algorithms.\n"
