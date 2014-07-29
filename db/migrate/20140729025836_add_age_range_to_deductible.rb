class AddAgeRangeToDeductible < ActiveRecord::Migration
  def change
    add_column :deductibles, :min_age, :integer
    add_column :deductibles, :max_age, :integer
  end
end
