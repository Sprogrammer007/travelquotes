class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name short_hand logo status}
	
	has_many :products, dependent: :destroy
	 
 	has_many :regions
 	has_many :provinces, :through => :regions
	#query scopes

	def self.recent(lmt)
		order('created_at desc').limit(lmt)
	end

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
end
