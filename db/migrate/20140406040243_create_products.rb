class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      
      # Policy Infos
      t.string :name
      t.string :product_number
      # t.datetime :eff_date
      t.text :description
      # t.string :purchase_url
      t.boolean :can_buy_after_30_days
      t.boolean :status, default: true
      t.references :company, index: true

      # Policy Age Variables
      # t.integer :min_age
      # t.integer :max_age
      # t.integer :max_age_with_kids
      # t.integer :max_kids_age

      # # Other Policy Variables
      # t.integer :min_trip_duration
      # t.integer :max_trip_duration
      # t.integer :min_adult
      # t.integer :max_adult
      # t.integer :min_dependant
      # t.integer :max_dependant
      # t.integer :min_price
      
      # t.boolean :super_visa_partial_refund
      # t.boolean :right_of_entry

      # # Policy Renewable Variables
      # t.boolean :renewable
      # t.integer :renewable_period
      # t.integer :renewable_max_age

      # # Other
      # t.boolean :follow_ups

      t.timestamps
    end
  end
end
