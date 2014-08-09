class AddMinRateTypeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :min_rate_type, :string
    add_column :products, :min_date, :integer
    add_column :student_products, :min_rate_type, :string
    add_column :student_products, :min_date, :integer
  end
end
