class CreateFamilyDetails < ActiveRecord::Migration
  def change
    create_table :family_details do |t|
      t.integer :min_dependant
      t.integer :max_dependant
      t.integer :max_kids_age
      t.integer :max_age_with_kids
    end
  end
end
