class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
    	t.references :age_bracket, index: true
      t.references :product, index: true
     	t.integer :sum_insured
     	t.boolean :preex
      t.integer :effective_date
      t.integer :rate
      t.timestamps
    end
  end
end
