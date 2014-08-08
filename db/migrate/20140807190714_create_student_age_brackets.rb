class CreateStudentAgeBrackets < ActiveRecord::Migration
  def change
    create_table :student_age_brackets do |t|
      t.references :student_product
      t.integer :min_age
      t.integer :max_age
      t.integer :min_trip_duration
      t.integer :max_trip_duration
      t.boolean :preex

      t.timestamps
    end
  end
end
