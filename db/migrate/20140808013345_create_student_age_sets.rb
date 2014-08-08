class CreateStudentAgeSets < ActiveRecord::Migration
  def change
    create_table :student_age_sets, :id => false  do |t|
      t.references :student_age_bracket, index: true
      t.references :student_version, index: true
     
    end
  end
end
