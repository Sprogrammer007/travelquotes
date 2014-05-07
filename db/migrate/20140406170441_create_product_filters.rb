class CreateProductFilters < ActiveRecord::Migration
  def change
    create_table :product_filters do |t|
    	t.string :category
      t.string :name
      t.string :policy_type
      t.text :descriptions
    end
  end
end
