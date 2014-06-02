class CreateLegalTexts < ActiveRecord::Migration
  def change
    create_table :legal_texts do |t|
      t.references :product
      t.references :legal_text_category
      t.string :policy_type
      t.text :description
      t.datetime  :effective_date
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
