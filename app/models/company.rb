class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name short_hand logo status}
	
	has_many :products, dependent: :destroy
	 
 	has_many :regions
 	has_many :provinces, :through => :regions

	#query scopes
  scope :active, -> { where(status: true) }

<<<<<<< HEAD

	def show_table(aa)
		aa.attributes_table do
      aa.row :short_hand
      aa.row :logo do
        aa.image_tag(self.logo)
      end
      aa.row :status do |c|
				if c.status
					aa.status_tag("Active", :ok)
				else
					aa.status_tag("Not Active")
				end
			end

    end
	end
=======
  validates :name, :logo, presence: true
  validates :status, inclusion: { in: [true, false] }
  
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
end
