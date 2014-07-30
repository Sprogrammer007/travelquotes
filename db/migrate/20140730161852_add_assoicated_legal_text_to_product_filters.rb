class AddAssoicatedLegalTextToProductFilters < ActiveRecord::Migration
  def change
    add_column :product_filters, :associated_lt_id, :integer
  end
end
