class CreateStudentFilterSets < ActiveRecord::Migration
  def change
    create_table :student_filter_sets, :id => false  do |t|
      t.references :student_filter, index: true
      t.references :student_product, index: true
    end
  end
end
