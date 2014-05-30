class SingleDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age }
  
  has_one :version, as: :detail, dependent: :destroy
  
  def has_special_rate?
    false
  end
end
