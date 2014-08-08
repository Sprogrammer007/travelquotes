class StudentLgParentCat < ActiveRecord::Base
  DEFAULT_HEADER = %w{name order popup_description}
  has_many :student_lg_cats, dependent: :destroy

  before_save :calc_order
  before_destroy :destroy_order_change

  def next
    StudentLgParentCat.where("student_lg_parent_cats.order > ?", self.order).order("student_lg_parent_cats.order ASC")
  end

  def prev
    StudentLgParentCat.where("student_lg_parent_cats.order < ?", self.order).order("student_lg_parent_cats.order DESC")
  end

  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      if new_record?
        largest_order = StudentLgParentCat.all.pluck(:order).max
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
