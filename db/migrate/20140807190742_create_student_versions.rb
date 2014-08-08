class CreateStudentVersions < ActiveRecord::Migration
  def change
    create_table :student_versions do |t|
      t.references :student_product, index: true
      t.string :detail_type
      t.integer :detail_id
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
