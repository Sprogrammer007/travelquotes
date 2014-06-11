class LegalTextCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{legal_text_parent_category_id name order popup_description}

  has_many :legal_texts, dependent: :destroy
  belongs_to :legal_text_parent_category
  before_save :calc_order
  def self.category_selections
    h = Hash.new 
    LegalTextParentCategory.all.map do |text| 
      if text.legal_text_categories
        h[text.name] =  text.legal_text_categories.map { |l| [l.name , l.id] }
      end
    end
    h
  end

  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      largest_order = LegalTextCategory.all.pluck(:order).max
      self.order = (largest_order + 1)
    end
end
