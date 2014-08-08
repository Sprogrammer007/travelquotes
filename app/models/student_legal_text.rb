class StudentLegalText < ActiveRecord::Base
  DEFAULT_HEADER = %w{student_product_id student_lg_cat description status}

  belongs_to :student_product
  belongs_to :student_lg_cat
  attr_accessor :parent_category

  def self.ordered
    joins(:student_lg_cat => [:student_lg_parent_cat]).order("student_lg_parent_cats.order asc").order("student_lg_cats.order asc")
  end
  
end
