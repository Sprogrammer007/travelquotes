class CreateRefundableTexts < ActiveRecord::Migration
  def change
    create_table :refundable_texts do |t|
      t.references :policy, index: true
      t.string :describition
      t.string :policy_type

      t.timestamps
    end
  end
end
