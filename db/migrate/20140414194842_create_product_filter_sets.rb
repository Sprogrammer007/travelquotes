class CreateProductFilterSets < ActiveRecord::Migration
  def change
    create_table :product_filter_sets, :id => false do |t|
      t.references :product_filter, index: true
      t.references :product, index: true

    end
  end
end
