class LegalTextParentCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{name order}
  has_many :legal_text_categories, dependent: :destroy

  before_save :calc_order
  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      largest_order = LegalTextParentCategory.all.pluck(:order).max
      self.order = (largest_order + 1)
    end
end
