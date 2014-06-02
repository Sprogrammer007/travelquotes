class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions, :id => false do |t|
      t.references :province, index: true
      t.references :company, index: true
    end
   
  end
end
