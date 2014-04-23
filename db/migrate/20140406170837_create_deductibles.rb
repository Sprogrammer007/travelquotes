class CreateDeductibles < ActiveRecord::Migration
  def change
    create_table :deductibles do |t|
    	t.references :product
    	t.integer :amount
      t.integer :mutiplier
      t.string :condition
      t.timestamps
    end
  end
end
