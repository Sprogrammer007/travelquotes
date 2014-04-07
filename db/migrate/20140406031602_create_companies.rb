class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :short_hand
      t.string :logo

      t.timestamps
    end
  end
end
