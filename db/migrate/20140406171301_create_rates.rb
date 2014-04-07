class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :age_bracket, index: true
      t.integer :rate
      t.integer :eff_dat

      t.timestamps
    end
  end
end
