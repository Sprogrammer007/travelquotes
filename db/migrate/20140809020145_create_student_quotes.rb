class CreateStudentQuotes < ActiveRecord::Migration
  def change
    create_table :student_quotes do |t|
      t.string :quote_id, index: true
      t.string :client_ip
      t.string :email
      t.datetime :leave_home
      t.datetime :return_home
      t.string :deductible_filter
      t.boolean :has_preex
      t.string :traveler_type
      t.timestamps
    end
  end
end
