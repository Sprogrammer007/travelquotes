class TravelerMember < ActiveRecord::Base
  belongs_to :quote

  scope :adult, -> { where(:member_type => "Adult") }
  scope :dependent, -> { where(:member_type => "Dependent") }
end
