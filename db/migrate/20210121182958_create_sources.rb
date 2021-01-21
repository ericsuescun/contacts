class CreateSources < ActiveRecord::Migration[6.0]
  def change
    create_table :sources do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename
      t.string :order
      t.string :status

      t.timestamps
    end
  end
end
