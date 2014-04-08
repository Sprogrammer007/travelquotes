class CreateAgeBrackets < ActiveRecord::Migration
  def change
    create_table :age_brackets do |t|
    	t.string :range
      t.references :policy, index: true
      t.integer :min_age
      t.integer :max_age

      t.timestamps
    end
  end
end
