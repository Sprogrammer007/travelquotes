class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.references :product, index: true
      t.string :type
      t.string :detail_type
      t.integer :detail_id
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
