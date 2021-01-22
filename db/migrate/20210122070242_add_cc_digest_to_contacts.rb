class AddCcDigestToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :cc_digest, :string
  end
end
