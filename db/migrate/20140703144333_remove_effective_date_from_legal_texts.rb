class RemoveEffectiveDateFromLegalTexts < ActiveRecord::Migration
  def change
    remove_column :legal_texts, :effective_date
  end
end
