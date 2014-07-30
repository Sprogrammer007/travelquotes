class AddPolicyTypeToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :policy_type, :string
  end
end
