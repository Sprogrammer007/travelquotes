class CreateAgeBrackets < ActiveRecord::Migration
	def change
		create_table :age_brackets do |t|
			t.references :product
			t.string :range
			t.integer :min_age
			t.integer :max_age
			

			t.timestamps
		end
	end
end
