class Import < ApplicationRecord
  belongs_to :user

  require 'csv'

  def self.import(file)
  	custom = %i[name birth_date tel address credit_card franchise email]
  	CSV.foreach(file.path, headers: custom, encoding: 'iso-8859-1:utf-8') do |row|
  		Import.create!(row.to_hash.merge(user_id: 1))
  	end
  end

end
