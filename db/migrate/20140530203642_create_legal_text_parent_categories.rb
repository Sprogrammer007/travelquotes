class CreateLegalTextParentCategories < ActiveRecord::Migration
  def change
    create_table :legal_text_parent_categories do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
