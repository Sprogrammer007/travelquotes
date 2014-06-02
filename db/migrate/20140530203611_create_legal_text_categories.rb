class CreateLegalTextCategories < ActiveRecord::Migration
  def change
    create_table :legal_text_categories do |t|
      t.references :legal_text_parent_category
      t.string :name  
      t.integer :order

      t.timestamps
    end
  end
end
