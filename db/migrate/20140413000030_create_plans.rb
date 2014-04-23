class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :product, index: true
      t.string :unique_id
      t.string :type
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
