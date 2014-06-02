class TravelerMember < ActiveRecord::Base
  belongs_to :quote

<<<<<<< HEAD
=======
  validates :birthday, presence: true

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  scope :adult, -> { where(:member_type => "Adult") }
  scope :dependent, -> { where(:member_type => "Dependent") }
end
