class Deductible < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id amount mutiplier condition }

  belongs_to :product


end
