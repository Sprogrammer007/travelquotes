class CreateSumInsureds < ActiveRecord::Migration
  def change
    create_table :sum_insureds do |t|
    
      t.references :age_bracket, index: true
      t.integer :max_age
     	t.integer :amount
      t.timestamps
    end
  end
end
