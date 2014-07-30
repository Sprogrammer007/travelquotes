class AddPdfToProducts < ActiveRecord::Migration
  def change
    add_attachment :products, :pdf
  end
end
