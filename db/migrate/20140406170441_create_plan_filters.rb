class CreatePlanFilters < ActiveRecord::Migration
  def change
    create_table :plan_filters do |t|
    	t.references :product
    	t.string :category
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
