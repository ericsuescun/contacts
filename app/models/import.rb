class Import < ApplicationRecord
  belongs_to :user

  require 'csv'

  validates :filename, presence: true

  def self.import(file, user_id)
    user = User.find(user_id)
  	custom = %i[name birth_date tel address credit_card franchise email]
  	CSV.foreach(file.path, headers: custom, encoding: 'iso-8859-1:utf-8') do |row|
  		user.imports.create!(row.to_hash.merge(filename: file.original_filename))
  	end
  end
end
