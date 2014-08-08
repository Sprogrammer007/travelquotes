class CreateStudentFamilyDetails < ActiveRecord::Migration
  def change
    create_table :student_family_details do |t|
      t.integer :min_age
      t.integer :max_age
      t.integer :min_dependant
      t.integer :max_dependant
      t.integer :min_adult
      t.integer :max_adult
      t.integer :max_kids_age
      t.integer :max_age_with_kids
      t.boolean :has_family_rate
    end
  end
end
