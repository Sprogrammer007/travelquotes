class LegalTextCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{legal_text_parent_category_id name order}

  has_many :legal_texts, dependent: :destroy
  belongs_to :legal_text_parent_category

  def self.category_selections
    h = Hash.new 
    LegalTextParentCategory.all.map do |text| 
      if text.legal_text_categories
        h[text.name] =  text.legal_text_categories.map { |l| [l.name , l.id] }
      end
    end
    h
  end
end
