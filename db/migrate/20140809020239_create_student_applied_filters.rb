class CreateStudentAppliedFilters < ActiveRecord::Migration
  def change
    create_table :student_applied_filters, :id => false do |t|
      t.references :student_quote, index: true
      t.references :student_filter, index: true

    end
  end
end
