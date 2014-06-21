class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.attachment :logo
      t.boolean :status, default: true
      
      t.timestamps
    end
  end
end
