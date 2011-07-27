require 'test/unit'
require 'crypt/idea'
require 'fileutils'

class TestIdea < Test::Unit::TestCase

	def setup
	end

	def teardown
	end
	
    def test_init
	  assert_nothing_raised(RuntimeError) {
        idea_en = Crypt::IDEA.new("Who was John Galt and where's my breakfast?", Crypt::IDEA::ENCRYPT)  
      }
    end
    
  def test_block_size
    idea_en = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT) 
    assert_equal(8, idea_en.block_size(), "Wrong block size")
  end

  def test_pair
    idea_en = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT) 
    orig_l, orig_r = [0xfedcba98, 0x76543210] 
    l, r = idea_en.crypt_pair(orig_l, orig_r)
    assert_equal(0x05627e79, l)
    assert_equal(0x69476521, r)
    idea_de = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::DECRYPT) 
    l, r = idea_de.crypt_pair(l, r)
    assert_equal(orig_l, l)
    assert_equal(orig_r, r)
  end

  def test_block
    idea_en = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT) 
    block = "norandom"
    encryptedBlock = idea_en.encrypt_block(block)
    assert_equal("\235\003\326u\001\330\361\t", encryptedBlock)
    idea_de = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::DECRYPT) 
    decryptedBlock = idea_de.decrypt_block(encryptedBlock)
    assert_equal(block, decryptedBlock)
  end
	
  def test_string
    length = 25 + rand(12)
    userkey = ""
    length.times { userkey << rand(256).chr }
    idea_en = Crypt::IDEA.new(userkey, Crypt::IDEA::ENCRYPT) 
    string = "This is a string which is not a multiple of 8 characters long"
    encryptedString = idea_en.encrypt_string(string)
    idea_de = Crypt::IDEA.new(userkey, Crypt::IDEA::DECRYPT) 
    decryptedString = idea_de.decrypt_string(encryptedString)
    assert_equal(string, decryptedString)
  end
  
  def test_file
    plainText = "This is a multi-line string\nwhich is not a multiple of 8 \ncharacters long."
    plainFile = File.new('plain.txt', 'wb+')
    plainFile.puts(plainText)
    plainFile.close()
    idea_en = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT) 
    idea_en.encrypt_file('plain.txt', 'crypt.txt')
    idea_de = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::DECRYPT) 
    idea_de.decrypt_file('crypt.txt', 'decrypt.txt')
    decryptFile = File.new('decrypt.txt', 'rb')
    decryptText = decryptFile.readlines().join('').chomp()
    decryptFile.close()
    assert_equal(plainText, decryptText)
    FileUtils.rm('plain.txt')
    FileUtils.rm('crypt.txt')
    FileUtils.rm('decrypt.txt')
  end

end