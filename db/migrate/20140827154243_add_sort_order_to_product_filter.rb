class AddSortOrderToProductFilter < ActiveRecord::Migration
  def change
    add_column :product_filters, :sort_order, :integer
    add_column :student_filters, :sort_order, :integer
  end
end
