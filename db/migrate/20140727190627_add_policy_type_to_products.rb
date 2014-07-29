class AddPolicyTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :policy_type, :string
  end
end
