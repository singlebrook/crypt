--- !ruby/object:Gem::Specification 
rubygems_version: 0.8.10
specification_version: 1
name: crypt
version: !ruby/object:Gem::Version 
  version: 1.1.4
date: 2006-08-06
summary: "The Crypt library is a pure-ruby implementation of a number of popular
  encryption algorithms. Block cyphers currently include Blowfish, GOST, IDEA, and
  Rijndael (AES). Cypher Block Chaining (CBC) has been implemented. Twofish,
  Serpent, and CAST256 are planned for release soon."
require_paths: 
  - "."
email: kernighan_rich@rubyforge.org
homepage: http://crypt.rubyforge.org/
rubyforge_project: crypt
description: 
autorequire: 
default_executable: 
bindir: bin
has_rdoc: false
required_ruby_version: !ruby/object:Gem::Version::Requirement 
  requirements: 
    - 
      - ">"
      - !ruby/object:Gem::Version 
        version: 0.0.0
  version: 
platform: ruby
authors: 
  - Richard Kernahan
files: 
  - crypt/blowfish-tables.rb
  - crypt/blowfish.rb
  - crypt/cbc.rb
  - crypt/gost.rb
  - crypt/idea.rb
  - crypt/noise.rb
  - crypt/purerubystringio.rb
  - crypt/rijndael-tables.rb
  - crypt/rijndael.rb
  - crypt/stringxor.rb
  - test/break-idea.rb
  - test/devServer.rb
  - test/test-blowfish.rb
  - test/test-gost.rb
  - test/test-idea.rb
  - test/test-rijndael.rb
test_files: []
rdoc_options: []
extra_rdoc_files: []
executables: []
extensions: []
requirements: []
dependencies: []
