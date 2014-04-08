class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      
      t.string :name
      t.references :policy, index: true
      t.references :category, index: true
      t.string :description
      t.integer :order

      t.timestamps
    end
  end
end
