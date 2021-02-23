class Franchise < ApplicationRecord
  require 'csv'
  require 'concerns/franchises_data'

  validates :prefix, presence: true
  validates :prefix, format: { with: /\A[0-9,\-]+\Z/, message: "different from numbers, hyphen, spaces and commas" }

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z,\&\s]+\Z/, message: "forbiden characters" }

  validates :number_length, presence: true
  validates :number_length, format: { with: /\A[0-9,\-]+\Z/, message: "different from numbers, hyphen, spaces and commas" }

  def self.import(file)
    CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      Franchise.create(row.to_hash)
    end
  end

  def self.name_from_number(card_number)
    franchises = FranchisesData::FRANCHISES

    result = []
    franchises_with_prefix = franchises.map do |key, value|
      value[:prefix].each do |prefix|
        result << [ prefix, key ]
      end
    end
    result.compact.sort.reverse!
    name = result.select{|data| card_number.to_s.start_with?(data[0].to_s) }
    if name != []
      return name[0][1].to_s
    else
      ""
    end
  end
end
