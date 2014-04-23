class Province < ActiveRecord::Base
  DEFAULT_HEADER = %w{name short_hand}
 
 	has_many :regions, :dependent => :destroy
 	has_many :companies, :through => :regions

 	attr_accessor :from_existing, :existing_name, :company_id

end
