class StudentLgCat < ActiveRecord::Base

  DEFAULT_HEADER = %w{student_lg_parent_cat_id name order popup_description}

  has_many :student_legal_texts, dependent: :destroy
  has_one :student_filter, foreign_key: "associated_lt_id"
  belongs_to :student_lg_parent_cat
  before_save :calc_order
  before_destroy :destroy_order_change

  def self.category_selections(product_id)
    p = StudentProduct.find(product_id)
    category_ids = p.student_legal_texts.pluck(:student_lg_cat_id)
    h = Hash.new 
    StudentLgParentCat.all.map do |text| 
      if text.student_lg_cats
        filtered_categories = text.student_lg_cats.select { |l| filter_check(p, l.id) }
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

  def self.get_legal_texts_compare_option(applied_filters)
    options = {}
    options["Filtered"] = StudentLgCat.get_legal_texts_by_filter(applied_filters)
    options["Not Filtered"] = StudentLgCat.get_lts_after_filters()
    return options
  end

  #gets only the legal text that the quote has applied filters for
  def self.get_legal_texts_by_filter(applied_filters)
    @applied_lts = []
    options = []
    if applied_filters.any?
      lt_ids = applied_filters.pluck(:associated_lt_id).uniq
      @applied_lts = StudentLgCat.find(lt_ids)
    end
    
    @applied_lts.each do |lt|
      options << [lt.name, lt.id]
    end

    return options
  end

  def self.get_lts_after_filters()
    lts = StudentLgCat.categories_by_order().values.flatten()
    options = []
    if @applied_lts.any?
      lts = lts - @applied_lts
    end
    lts.each do |lt|
      next if lt.name == "Definitions"
      options << [lt.name, lt.id]
    end
    return options
  end

  def self.filter_check(product, id)
    p = product.student_legal_texts.where(:student_lg_cat_id => id)
    if (p.length == 1) && (p.first.policy_type == "Both")
      false
    elsif (p.length >= 2)
      false
    else
      true
    end
  end

  def self.categories_by_order
    categories = {} 
    StudentLgParentCat.all.order("student_lg_parent_cats.order ASC").each do |ltp|
      categories[ltp.name] = StudentLgCat.where(:student_lg_parent_cat_id => ltp).order("student_lg_cats.order ASC")
    end

    return categories
  end

  def self.map_by_parent()
    f = {}
    StudentLgCat.categories_by_order.each do |k, v|
      n = []
      # Loop through each set of categories to get name and id in array
      v.each do |l|
        n << [l.name, l.id]
      end
      f[k] = n
    end
    return f
  end
  

  def next
    student_lg_parent_cat.student_lg_cats.where("student_lg_cats.order > ?", self.order).order("student_lg_cats.order ASC")
  end

  def prev
    student_lg_parent_cat.student_lg_cats.where("student_lg_cats.order < ?", self.order).order("student_lg_cats.order DESC")
  end

  private
    #new record order always going to be the last order + 1
    #this is to prevent any order confusion during new category creation
    def calc_order
      if new_record?
        largest_order = StudentLgCat.all.pluck(:order).max
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
