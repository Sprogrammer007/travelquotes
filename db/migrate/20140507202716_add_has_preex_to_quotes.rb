class AddHasPreexToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :has_preex, :boolean
  end
end
