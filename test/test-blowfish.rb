# testblowfish.rb  bryllig

require 'test/unit'
require 'crypt/blowfish'
require 'crypt/cbc'
require 'fileutils'

class TestBlowfish < Test::Unit::TestCase
  
  def setup
     @bf = Crypt::Blowfish.new("Who is John Galt?")  # Schneier's test key
  end
  
  def teardown
  end
  
  def test_block_size
    assert_equal(8, @bf.block_size(), "Wrong block size")
  end

  def test_initialize
    assert_raise(RuntimeError) {
      b0 = Crypt::Blowfish.new("")
    }
    assert_nothing_raised() {
      b1 = Crypt::Blowfish.new("1")
    }
    assert_nothing_raised() {
      b56 = Crypt::Blowfish.new("1"*56)
    }
    assert_raise(RuntimeError) {
      b57 = Crypt::Blowfish.new("1"*57)
    }
  end

  def test_pair
    bf = Crypt::Blowfish.new("Who is John Galt?")  
    orig_l, orig_r = [0xfedcba98, 0x76543210] 
    l, r = bf.encrypt_pair(orig_l, orig_r)
    assert_equal(0xcc91732b, l)
    assert_equal(0x8022f684, r)
    l, r = bf.decrypt_pair(l, r)
    assert_equal(orig_l, l)
    assert_equal(orig_r, r)
  end

  def test_block
    bf = Crypt::Blowfish.new("Who is John Galt?") 
    block = "norandom"
    encryptedBlock = bf.encrypt_block(block)
    assert_equal("\236\353k\321&Q\"\220", encryptedBlock)
    decryptedBlock = bf.decrypt_block(encryptedBlock)
    assert_equal(block, decryptedBlock)
  end
  
  def test_string
    length = 30 + rand(26)
    userkey = ""
    length.times { userkey << rand(256).chr }
    bf = Crypt::Blowfish.new(userkey) 
    string = "This is a string which is not a multiple of 8 characters long"
    encryptedString = bf.encrypt_string(string)
    decryptedString = bf.decrypt_string(encryptedString)
    assert_equal(string, decryptedString)
    secondstring = "This is another string to check repetitive use."
    encryptedString = bf.encrypt_string(secondstring)
    decryptedString = bf.decrypt_string(encryptedString)
    assert_equal(secondstring, decryptedString)
    
  end
  
  def test_file
    plainText = "This is a multi-line string\nwhich is not a multiple of 8 \ncharacters long."
    plainFile = File.new('plain.txt', 'wb+')
    plainFile.puts(plainText)
    plainFile.close()
    bf = Crypt::Blowfish.new("Who is John Galt?")
    bf.encrypt_file('plain.txt', 'crypt.txt')
    bf.decrypt_file('crypt.txt', 'decrypt.txt')
    decryptFile = File.new('decrypt.txt', 'rb')
    decryptText = decryptFile.readlines().join('').chomp()
    decryptFile.close()
    assert_equal(plainText, decryptText)
    FileUtils.rm('plain.txt')
    FileUtils.rm('crypt.txt')
    FileUtils.rm('decrypt.txt')
  end

end
