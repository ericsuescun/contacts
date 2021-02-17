class Franchise < ApplicationRecord
  require 'csv'

  validates :prefix, presence: true
  validates :prefix, format: { with: /\A[0-9,\s\-]+\Z/, message: "different from numbers, hyphen, spaces and commas" }

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z,\&\s]+\Z/, message: "forbiden characters" }

  validates :number_length, presence: true
  validates :number_length, format: { with: /\A[0-9,\s\-]+\Z/, message: "different from numbers, hyphen, spaces and commas" }

  def self.import(file)
    CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      Franchise.create!(row.to_hash)
    end
  end

  def self.name_from_number(card_number:)
    # Code that returns the name based on the card-number
  end
end
