class ChangeColumnFamilyRateFamily < ActiveRecord::Migration
  def change
    remove_column :family_details, :has_family_rate
    add_column :family_details, :family_rate_type, :string
  end
end
