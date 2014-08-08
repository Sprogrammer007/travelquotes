class CreateStudentLegalTexts < ActiveRecord::Migration
  def change
    create_table :student_legal_texts do |t|
      t.references :student_product
      t.references :student_lg_cat
      t.text :description
      t.datetime  :effective_date
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
