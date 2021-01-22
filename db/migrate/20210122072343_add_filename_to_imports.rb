class AddFilenameToImports < ActiveRecord::Migration[6.0]
  def change
    add_column :imports, :filename, :string
  end
end
