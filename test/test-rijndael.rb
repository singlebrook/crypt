require 'test/unit'
require 'crypt/rijndael'
require 'fileutils'

class TestRijndael < Test::Unit::TestCase

	def setup
	end

	def teardown
	end
	
    def test_init
	  assert_raise(RuntimeError) {
        rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 64)
      }
	  assert_raise(RuntimeError) {
        rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 128, 64)
      }
    end
    
    def test_block_size
      rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 128, 256)
      assert_equal(32, rijndael.block_size)
      rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 256, 128)
      assert_equal(16, rijndael.block_size)
    end
    
    def test_block
      rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 128, 128)
      block = "\341q\214NIj\023u\343\330s\323\354$g\277"
      encryptedBlock = rijndael.encrypt_block(block)
      assert_equal("\024\246^\332T\323x`\323yB\352\2159\212R", encryptedBlock)
      decryptedBlock = rijndael.decrypt_block(encryptedBlock)
      assert_equal(block, decryptedBlock)
      rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?", 128, 256)
      assert_raise(RuntimeError) {
        encryptedBlock = rijndael.encrypt_block(block)
      }
    end
	
  def test_string
    rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?")
    string = "This is a string which is not a multiple of 8 characters long"
    encryptedString = rijndael.encrypt_string(string)
    decryptedString = rijndael.decrypt_string(encryptedString)
    assert_equal(string, decryptedString)
  end
  
  def test_file
    plainText = "This is a multi-line string\nwhich is not a multiple of 8 \ncharacters long."
    plainFile = File.new('plain.txt', 'wb+')
    plainFile.puts(plainText)
    plainFile.close()
    rijndael = Crypt::Rijndael.new("Who is this John Galt guy, anyway?")
    rijndael.encrypt_file('plain.txt', 'crypt.txt')
    rijndael.decrypt_file('crypt.txt', 'decrypt.txt')
    decryptFile = File.new('decrypt.txt', 'rb')
    decryptText = decryptFile.readlines().join('').chomp()
    decryptFile.close()
    assert_equal(plainText, decryptText)
    FileUtils.rm('plain.txt')
    FileUtils.rm('crypt.txt')
    FileUtils.rm('decrypt.txt')
  end

end