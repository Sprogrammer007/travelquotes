class CreateAgeBrackets < ActiveRecord::Migration
	def change
		create_table :age_brackets do |t|
			t.references :product
			t.integer :min_age
			t.integer :max_age
			t.integer :min_trip_duration
      t.integer :max_trip_duration
      t.boolean :preex

			t.timestamps
		end
	end
end
