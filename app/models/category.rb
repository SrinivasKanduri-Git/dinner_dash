# frozen_string_literal: true

class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :items
  field :category, type: String

  validates :category, presence: true, uniqueness: { case_sensitive: false }
end
