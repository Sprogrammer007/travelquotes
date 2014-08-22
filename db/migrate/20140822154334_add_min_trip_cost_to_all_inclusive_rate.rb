class AddMinTripCostToAllInclusiveRate < ActiveRecord::Migration
  def change
    add_column :all_inclusive_rates, :min_trip_cost, :integer
  end
end
