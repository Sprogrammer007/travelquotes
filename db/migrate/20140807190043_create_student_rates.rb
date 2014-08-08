class CreateStudentRates < ActiveRecord::Migration
  def change
    create_table :student_rates do |t|
      t.references :student_age_bracket, index: true
      t.float :rate
      t.string :rate_type
      t.integer :sum_insured
      t.datetime  :effective_date
      t.string :status
      t.timestamps
    end
  end
end
