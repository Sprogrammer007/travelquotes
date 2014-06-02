class CreateLegalTexts < ActiveRecord::Migration
  def change
    create_table :legal_texts do |t|
      t.references :product
<<<<<<< HEAD
      t.string :name
=======
      t.references :legal_text_category
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      t.string :policy_type
      t.text :description
      t.datetime  :effective_date
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
