class AddQuoteSubTypeToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :quote_sub_type, :string
  end
end
