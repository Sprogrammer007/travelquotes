class CreateStudentLgParentCats < ActiveRecord::Migration
  def change
    create_table :student_lg_parent_cats do |t|
      t.string :name
      t.integer :order
      t.text :popup_description
    end
  end
end
