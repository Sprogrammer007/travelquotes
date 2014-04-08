class CreateCoverageCategories < ActiveRecord::Migration
  def change
    create_table :coverage_categories do |t|

			t.string :name	
      t.references :policy, index: true
      t.string :description
      t.integer :order

      t.timestamps
    end
  end
end
