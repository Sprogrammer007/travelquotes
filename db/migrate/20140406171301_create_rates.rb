class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
    	t.references :age_bracket, index: true
     	t.integer :rate
      t.string :rate_type
      t.integer :sum_insured
      t.datetime  :effective_date
      t.string :status
      t.timestamps
    end
  end
end
