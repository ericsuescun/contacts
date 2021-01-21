class CreateFranchises < ActiveRecord::Migration[6.0]
  def change
    create_table :franchises do |t|
      t.string :prefix
      t.string :name
      t.string :number_length

      t.timestamps
    end
  end
end
