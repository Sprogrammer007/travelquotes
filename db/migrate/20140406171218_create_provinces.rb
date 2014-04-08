class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
    	t.string :name
      t.references :company, index: true
      t.string :short_hand
      t.integer :order

      t.timestamps
    end
  end
end
