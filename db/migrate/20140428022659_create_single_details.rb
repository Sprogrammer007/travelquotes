class CreateSingleDetails < ActiveRecord::Migration
  def change
    create_table :single_details do |t|
      t.integer :min_age
      t.integer :max_age
    end
  end
end
