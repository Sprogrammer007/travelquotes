class CreatePlanFilterSets < ActiveRecord::Migration
  def change
    create_table :plan_filter_sets, :id => false do |t|
      t.references :plan_filter, index: true
      t.references :plan, index: true

    end
  end
end
