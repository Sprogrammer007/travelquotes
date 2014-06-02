class CreateDeductibles < ActiveRecord::Migration
  def change
    create_table :deductibles do |t|
    	t.references :product
    	t.integer :amount
<<<<<<< HEAD
      t.integer :mutiplier
      t.string :condition
=======
      t.float :mutiplier
      t.string :condition
      t.integer :age
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      t.timestamps
    end
  end
end
