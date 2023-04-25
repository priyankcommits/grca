class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name
      t.text :cover
      t.boolean :is_active, default: true
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end
