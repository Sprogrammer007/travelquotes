class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      
      # Policy Infos
      t.references :company, index: true
      t.string :name
      t.string :product_number
      t.text :description
      t.integer :min_price
      t.boolean :status, default: true
      t.string :purchase_url
      t.datetime :effective_date

      # Policy Age Variables
      # t.integer :min_age
      # t.integer :max_age
      # t.integer :min_adult
      # t.integer :max_adult

      # # Other
      # t.boolean :follow_ups

      t.timestamps
    end
  end
end
