class CreateStudentProducts < ActiveRecord::Migration
  def change
    create_table :student_products do |t|
        # Policy Infos
      t.references :company, index: true
      t.string :name
      t.string :policy_number
      t.text :description
      t.integer :min_price
      t.attachment :pdf
      t.boolean :can_buy_after_30_days
      t.boolean :can_renew_after_30_days
      t.integer :renewable_max_age

      t.boolean :preex
      t.integer :preex_max_age
      t.boolean :preex_based_on_sum_insured, default: false
      t.boolean :status, default: true
      t.string :purchase_url, default: "http://"
      t.datetime :rate_effective_date
      t.datetime :future_rate_effective_date
      t.datetime :effective_date
    end
  end
end
