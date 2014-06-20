class CreateDeductibles < ActiveRecord::Migration
  def change
    create_table :deductibles do |t|
    	t.references :product
    	t.integer :amount
      t.float :mutiplier
      # t.string :condition
      # t.integer :age
      t.timestamps
    end
  end
end
