class CreateTripValues < ActiveRecord::Migration
  def change
    create_table :trip_values do |t|
      t.references :policy, index: true
      t.integer :min_value
      t.integer :max_value

      t.timestamps
    end
  end
end
