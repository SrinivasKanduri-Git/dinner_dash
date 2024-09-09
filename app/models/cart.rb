# frozen_string_literal: true

class Cart
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_and_belongs_to_many :items
end
