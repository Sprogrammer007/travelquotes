class TravelerMember < ActiveRecord::Base
  belongs_to :quote

  validates :birthday, presence: true

  scope :adult, -> { where(:member_type => "Adult") }
  scope :dependent, -> { where(:member_type => "Dependent") }
end
