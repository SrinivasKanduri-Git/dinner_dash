# frozen_string_literal: true

class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :category
  field :title, type: String
  field :description, type: String
  field :price, type: Float

  validates_presence_of(:title, :description, :price)

  validates :title, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than: 0 }
  accepts_nested_attributes_for :category
end
