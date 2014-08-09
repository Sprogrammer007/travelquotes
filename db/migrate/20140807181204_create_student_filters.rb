class CreateStudentFilters < ActiveRecord::Migration
  def change
    create_table :student_filters do |t|
      t.string :category
      t.string :name
      t.integer :associated_lt_id
      t.text :descriptions
    end
  end
end
