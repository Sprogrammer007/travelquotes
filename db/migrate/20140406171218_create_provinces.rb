class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.references :company, index: true
      t.string :name
      t.string :short_hand
      t.integer :order

      t.timestamps
    end
  end
end
