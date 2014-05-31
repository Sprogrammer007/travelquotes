class LegalTextParentCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{name order}
  has_many :legal_text_categories, dependent: :destroy

end
