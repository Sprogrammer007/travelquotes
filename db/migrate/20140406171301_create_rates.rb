class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
    	
      t.references :age_bracket, index: true
      t.integer :eff_dat
      t.integer :rate
      t.timestamps
    end
  end
end
