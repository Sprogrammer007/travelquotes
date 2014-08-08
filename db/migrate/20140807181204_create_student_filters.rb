class CreateStudentFilters < ActiveRecord::Migration
  def change
    create_table :student_filters do |t|
      t.string :category
      t.string :name
      t.text :descriptions
    end
  end
end
