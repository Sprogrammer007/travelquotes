class CreateStudentLgCats < ActiveRecord::Migration
  def change
    create_table :student_lg_cats do |t|
      t.references :student_lg_parent_cat
      t.string :name  
      t.integer :order
      t.text :popup_description
    end
  end
end
