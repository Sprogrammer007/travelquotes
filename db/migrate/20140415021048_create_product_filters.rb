class CreateProductFilters < ActiveRecord::Migration
  def change
    create_table :product_filters do |t|

      t.string :name
      t.string :category
      t.references :product
      t.text :description
      t.timestamps
    end
  end
end
