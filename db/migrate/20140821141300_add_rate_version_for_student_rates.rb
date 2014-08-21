class AddRateVersionForStudentRates < ActiveRecord::Migration
  def change
    add_column :student_rates, :rate_version, :string
  end
end
