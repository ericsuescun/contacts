class ChangeDataTypeForBirthDateInImports < ActiveRecord::Migration[6.0]
  def self.up
  	change_table :imports do |t|
  		t.change :birth_date, :string
  	end
  end

  def self.down
  	change_table :imports do |t|
  		t.change :birth_date, :date
  	end
  end
end
