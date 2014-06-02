class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      
      # Policy Infos
      t.references :company, index: true
      t.string :name
<<<<<<< HEAD
      t.string :product_number
=======
      t.string :policy_number
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      t.text :description
      t.integer :min_price
      
      t.boolean :can_buy_after_30_days
<<<<<<< HEAD

      t.boolean :renewable
      t.integer :renewable_period
=======
      t.boolean :can_renew_after_30_days
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      t.integer :renewable_max_age

      t.boolean :preex
      t.integer :preex_max_age
<<<<<<< HEAD
      t.boolean :follow_ups
=======
      t.boolean :preex_based_on_sum_insured
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      t.boolean :status, default: true
      t.string :purchase_url
      t.datetime :effective_date

      t.timestamps
    end
  end
end
