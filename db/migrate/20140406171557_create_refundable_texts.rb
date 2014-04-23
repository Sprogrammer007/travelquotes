class CreateRefundableTexts < ActiveRecord::Migration
  def change
      create_table :refundable_texts do |t|
      t.string :describition

      t.timestamps
    end
  end
end
