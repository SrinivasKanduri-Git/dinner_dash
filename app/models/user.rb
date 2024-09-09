# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  after_create :create_cart

  has_one :cart, dependent: :destroy
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :phone_number, type: Array, default: []
  field :dob, type: Date
  field :status, type: Boolean, default: false

  validates_presence_of(:first_name, :last_name, :email, :phone_number, :dob)

  has_secure_password

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validate :validate_phone_numbers

  private

  def create_cart
    Cart.create(user: self)
  end

  def validate_phone_numbers
    phone_number.each do |number|
      errors.add(:phone_number, 'is invalid') unless number =~ /\A([6-9]{1}[0-9]{9})\z/
    end
  end
end
