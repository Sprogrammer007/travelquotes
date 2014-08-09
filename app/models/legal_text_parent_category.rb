class LegalTextParentCategory < ActiveRecord::Base
  DEFAULT_HEADER = %w{name order popup_description}
  has_many :legal_text_categories, dependent: :destroy

  before_save :calc_order
  before_destroy :destroy_order_change

  def next
    LegalTextParentCategory.where("legal_text_parent_categories.order > ?", self.order).order("legal_text_parent_categories.order ASC")
  end

  def prev
    LegalTextParentCategory.where("legal_text_parent_categories.order < ?", self.order).order("legal_text_parent_categories.order DESC")
  end

  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      if new_record?
        largest_order = LegalTextParentCategory.all.pluck(:order).max
        if largest_order
          self.order = (largest_order + 1)
        else
          self.order = 1
        end
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
