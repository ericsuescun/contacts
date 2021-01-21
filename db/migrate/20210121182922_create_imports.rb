class CreateImports < ActiveRecord::Migration[6.0]
  def change
    create_table :imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :birth_date
      t.string :tel
      t.string :address
      t.string :credit_card
      t.string :franchise
      t.string :email
      t.string :import_errors

      t.timestamps
    end
  end
end
