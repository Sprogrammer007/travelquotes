class Province < ActiveRecord::Base
	DEFAULT_HEADER = %w{name company_id short_hand order}
  belongs_to :company
end
