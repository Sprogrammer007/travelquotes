class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
    	t.string :name
      t.string :short_hand
      t.string :country
    end
  end
end
