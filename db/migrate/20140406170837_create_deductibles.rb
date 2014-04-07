class CreateDeductibles < ActiveRecord::Migration
  def change
    create_table :deductibles do |t|
      t.references :policy, index: true
      t.integer :amount
      t.integer :mutiplier
      t.integer :age
      t.string :condition

      t.timestamps
    end
  end
end
