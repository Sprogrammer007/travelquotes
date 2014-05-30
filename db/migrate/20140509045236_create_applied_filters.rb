class CreateAppliedFilters < ActiveRecord::Migration
  def change
    create_table :applied_filters, :id => false do |t|
      t.references :quote, index: true
      t.references :product_filter, index: true
    end
  end
end
