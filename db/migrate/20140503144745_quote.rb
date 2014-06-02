class Quote < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :quote_id, index: true
      t.string :client_ip
      t.string :quote_type
      t.string :email
      t.boolean :renew
      t.datetime :renew_expire_date
      t.datetime :leave_home
      t.datetime :return_home
      t.boolean :apply_from
      t.string :deductible_filter
      t.boolean :has_preex
      t.datetime :arrival_date, default: nil
      t.integer :trip_cost
      t.integer :sum_insured
      t.string :traveler_type
      t.timestamps
    end
  end
end
