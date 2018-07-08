class Account < ApplicationRecord
  has_many :tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :lectures, dependent: :destroy

  validates :student_id, presence: true
  validates :login_password, presence: true
  before_save :encrypt

  SECURE = File.read("#{Rails.root}/config/master.key").chomp
  CIPHER = "aes-256-cbc"

  def encrypt
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    self.login_password = crypt.encrypt_and_sign(self.login_password)
  end

  def decrypt_password
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.decrypt_and_verify(self.login_password)
  end

  class << self
    def authenticate(id, password)
      acc = Account.find_by(student_id: id)
      acc if acc && acc.match_password?(password)
    end
  end

  def match_password?(password)
    password == decrypt_password
  end
end
