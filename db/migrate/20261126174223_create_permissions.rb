class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
       t.string :name, null: false
      t.string :module_name, null: false
      t.string :action, null: false
      t.text :description

      t.timestamps
    end

    add_index :permissions, :name, unique: true
    add_index :permissions,
              [:module_name, :action],
              unique: true
  end
end
