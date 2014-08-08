class CreateStudentCoupleDetails < ActiveRecord::Migration
  def change
    create_table :student_couple_details do |t|

      t.integer :min_age
      t.integer :max_age
      t.boolean :has_couple_rate
    end
  end
end
