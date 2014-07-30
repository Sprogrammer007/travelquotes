class LegalTextCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{legal_text_parent_category_id name order popup_description}

  has_many :legal_texts, dependent: :destroy
  has_one :product_filter, foreign_key: "associated_lt_id"
  belongs_to :legal_text_parent_category
  before_save :calc_order
  before_destroy :destroy_order_change

  def self.category_selections(product_id)
    p = Product.find(product_id)
    category_ids = p.legal_texts.pluck(:legal_text_category_id)
    h = Hash.new 
    LegalTextParentCategory.all.map do |text| 
      if text.legal_text_categories
        filtered_categories = text.legal_text_categories.select { |l| filter_check(p, l.id) }
        if filtered_categories.empty?
          h[text.name] = ["No More New Sub Categories For #{text.name}"]
        else
          h[text.name] =  filtered_categories.map do |l|
            [l.name , l.id] 
          end
        end
      end
    end
    h
  end

  def self.filter_check(product, id)
    p = product.legal_texts.where(:legal_text_category_id => id)
    if (p.length == 1) && (p.first.policy_type == "Both")
      false
    elsif (p.length >= 2)
      false
    else
      true
    end
  end

  def next
    legal_text_parent_category.legal_text_categories.where("legal_text_categories.order > ?", self.order).order("legal_text_categories.order ASC")
  end

  def prev
    legal_text_parent_category.legal_text_categories.where("legal_text_categories.order < ?", self.order).order("legal_text_categories.order DESC")
  end

  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      if new_record?
        largest_order = LegalTextCategory.all.pluck(:order).max
        self.order = (largest_order + 1)
      end
    end

    def destroy_order_change
      if self.next.any?
        self.next.each_with_index do |l, i|
          current_order = (self.order + i)
          l.update(order: current_order)
        end
      end
    end
end
