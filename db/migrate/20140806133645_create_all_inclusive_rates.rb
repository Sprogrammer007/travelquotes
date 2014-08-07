class CreateAllInclusiveRates < ActiveRecord::Migration
  def change
    create_table :all_inclusive_rates do |t|
      t.references :age_bracket, index: true
      t.float :rate
      t.string :rate_type
      t.integer :min_date
      t.integer :max_date
      t.integer :rate_trip_value
      t.integer :sum_insured
      t.datetime :effective_date
      t.string :status
      t.timestamps
    end
  end
end
