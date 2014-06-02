class CreateTravelerMembers < ActiveRecord::Migration
  def change
    create_table :traveler_members do |t|
      t.references :quote
      t.datetime :birthday
      t.string :gender
      t.string :member_type
    end
  end
end
