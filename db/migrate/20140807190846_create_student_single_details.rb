class CreateStudentSingleDetails < ActiveRecord::Migration
  def change
    create_table :student_single_details do |t|
      t.integer :min_age
      t.integer :max_age

    end
  end
end
