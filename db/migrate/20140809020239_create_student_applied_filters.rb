class CreateStudentAppliedFilters < ActiveRecord::Migration
  def change
    create_table :student_applied_filters, :id => false do |t|
      t.references :quote, index: true
      t.references :product_filter, index: true

    end
  end
end
