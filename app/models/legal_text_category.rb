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

  #gets only the legal text that the quote has applied filters for
  def self.get_legal_texts_by_filter(applied_filters, type)
    @applied_lts = []
    options = []
    if applied_filters.any?
      lt_ids = applied_filters.pluck(:associated_lt_id).uniq
      @applied_lts = LegalTextCategory.find(lt_ids)
    end
    
    @applied_lts.each do |lt|
      options << [lt.name, lt.id]
    end

    return options
  end

  def self.get_lts_after_filters(type)
    lts = LegalTextCategory.all
    options = []
    if @applied_lts.any?
      lts = lts - @applied_lts
    end
    lts.each do |lt|
      options << [lt.name, lt.id]
    end
    return options
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
