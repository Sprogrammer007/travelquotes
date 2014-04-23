class CreateAgeSets < ActiveRecord::Migration
  def change
    create_table :age_sets, :id => false  do |t|
      t.references :age_bracket, index: true
      t.references :plan, index: true
    end
  end
end
