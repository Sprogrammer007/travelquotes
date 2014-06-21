class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name status}
	
	has_many :products, dependent: :destroy
	 
 	has_many :regions
 	has_many :provinces, :through => :regions

	#query scopes
  scope :active, -> { where(status: true) }

  has_attached_file :logo, :default_url => ActionlleContror::Base.helpers.asset_path("no_logo.png", :digest => false)
  validates_attachment :logo, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates :name, presence: true
  validates :status, inclusion: { in: [true, false] }
  
end
