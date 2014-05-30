class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      
      # Policy Infos
      t.references :company, index: true
      t.string :name
      t.string :policy_number
      t.text :description
      t.integer :min_price
      
      t.boolean :can_buy_after_30_days
      t.boolean :can_renew_after_30_days

      t.boolean :renewable
      t.integer :renewable_period
      t.integer :renewable_max_age

      t.boolean :preex
      t.integer :preex_max_age
      t.boolean :follow_ups
      t.boolean :status, default: true
      t.string :purchase_url
      t.datetime :effective_date

      t.timestamps
    end
  end
end
