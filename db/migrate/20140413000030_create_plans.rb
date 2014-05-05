class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :product, index: true
      t.string :unique_id
      t.string :type
      t.string :detail_type
      t.string :detail_id
      t.boolean :can_buy_after_30_days

      t.boolean :renewable
      t.integer :renewable_period
      t.integer :renewable_max_age

      t.boolean :status, default: true

      t.timestamps
    end
  end
end
