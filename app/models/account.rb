class Account < ApplicationRecord
  has_many :tokens

  validates :student_id, :login_password, presence :true, uniqueness: {allow_blank: false}
  before_save :encrypt
  
  SECURE = File.read("#{Rails.root}/config/master.key").chomp
  CIPHER = "aes-256-cbc"

  def encrypt
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    self.login_password = crypt.encrypt_and_sign(self.login_password)
  end
  
  def decrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.decrypt_and_verify(password)
  end
end
