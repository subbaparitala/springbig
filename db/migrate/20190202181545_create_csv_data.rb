class CreateCsvData < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_data do |t|
      t.integer :row_id, null: false
      t.string :first
      t.string :last
      t.string :phone, null: false
      t.string :email, null:  false
      t.text :message
      t.boolean :is_failed, default: false
      t.references :identifier, foreign_key: true

      t.timestamps
    end
  end
end
