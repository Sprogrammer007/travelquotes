class CreateStudentTravelerMembers < ActiveRecord::Migration
  def change
    create_table :student_traveler_members do |t|
      t.references :student_quote
      t.datetime :birthday
      t.string :gender
      t.string :member_type
    end
  end
end
