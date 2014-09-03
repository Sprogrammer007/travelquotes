class AddPlanTypeToStudentQuotes < ActiveRecord::Migration
  def change
    add_column :student_quotes, :plan_type, :string
  end
end
