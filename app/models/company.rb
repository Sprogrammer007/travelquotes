class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name short_hand logo status}
	
	has_many :products, dependent: :destroy
	 
 	has_many :regions
 	has_many :provinces, :through => :regions

	#query scopes
  scope :active, -> { where(status: true) }

  validates :name, :logo, presence: true
  validates :status, inclusion: { in: [true, false] }
  
end
