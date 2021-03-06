class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /(\+84|0)\d{9,10}/
  enum role: [:locked, :user, :admin]
  has_many :image, as: :imageable
  has_many :categories
  has_many :songs
  has_many :albums
  has_many :authors
  has_many :singers
  has_many :lyrics
  has_many :likes
  has_many :comments
  has_many :reports
  scope :by_role, ->{order role: :desc}
  scope :select_fields, ->{select :id, :name, :email, :phone, :created_at, :role}
  validates :name, presence: true, length:
    {maximum: Settings.validates.name.maximum}
  validates :email, presence: true, length:
    {maximum: Settings.validates.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length:
    {minimum: Settings.validates.password.minimum}, allow_nil: true
  validates :phone, length: {maximum: Settings.validates.phone.maximum},
    format: {with: VALID_PHONE_REGEX}, allow_nil: true

  attr_accessor :remember_token, :activation_token, :reset_token
  has_secure_password
  before_save :downcase_email
  before_create :create_activation_digest

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: User.digest(remember_token)
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_time.hours.ago
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
