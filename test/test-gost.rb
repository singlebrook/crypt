require 'test/unit'
require 'crypt/gost'
require 'fileutils'

class TestGost < Test::Unit::TestCase

	def setup
	end

	def teardown
	end
	
    def test_init
	  assert_nothing_raised(RuntimeError) {
        gost = Crypt::Gost.new("Whatever happened to Yuri Gagarin?")
      }
	  assert_nothing_raised(RuntimeError) {
        gost = Crypt::Gost.new("Whatever happened to Yuri?")
      }
    end
    
  def test_block_size
    gost = Crypt::Gost.new("Whatever happened to Yuri?")
    assert_equal(8, gost.block_size(), "Wrong block size")
  end

  def test_pair
    gost = Crypt::Gost.new("Whatever happened to Yuri?") 
    orig_l, orig_r = [0xfedcba98, 0x76543210] 
    l, r = gost.encrypt_pair(orig_l, orig_r)
    assert_equal(0xaefaf8f4, l)
    assert_equal(0xe24891b0, r)
    l, r = gost.decrypt_pair(l, r)
    assert_equal(orig_l, l)
    assert_equal(orig_r, r)
  end

  def test_block
    gost = Crypt::Gost.new("Whatever happened to Yuri?") 
    block = "norandom"
    encryptedBlock = gost.encrypt_block(block)
    assert_equal(".Vy\377\005\e3`", encryptedBlock)
    decryptedBlock = gost.decrypt_block(encryptedBlock)
    assert_equal(block, decryptedBlock)
  end
	
  def test_string
    length = 25 + rand(12)
    userkey = ""
    length.times { userkey << rand(256).chr }
    gost = Crypt::Gost.new(userkey) 
    string = "This is a string which is not a multiple of 8 characters long"
    encryptedString = gost.encrypt_string(string)
    decryptedString = gost.decrypt_string(encryptedString)
    assert_equal(string, decryptedString)
  end
  
  def test_file
    plainText = "This is a multi-line string\nwhich is not a multiple of 8 \ncharacters long."
    plainFile = File.new('plain.txt', 'wb+')
    plainFile.puts(plainText)
    plainFile.close()
    gost = Crypt::Gost.new("Whatever happened to Yuri?") 
    gost.encrypt_file('plain.txt', 'crypt.txt')
    gost.decrypt_file('crypt.txt', 'decrypt.txt')
    decryptFile = File.new('decrypt.txt', 'rb')
    decryptText = decryptFile.readlines().join('').chomp()
    decryptFile.close()
    assert_equal(plainText, decryptText)
    FileUtils.rm('plain.txt')
    FileUtils.rm('crypt.txt')
    FileUtils.rm('decrypt.txt')
  end

end