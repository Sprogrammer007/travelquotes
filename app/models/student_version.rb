class StudentVersion < ActiveRecord::Base

  DEFAULT_HEADER = %w{student_product_id type detail_type detail_id status}
  belongs_to :student_product

  has_many :student_age_sets, dependent: :destroy
  has_many :student_age_brackets, :through => :student_age_sets

  belongs_to :detail, polymorphic: true, dependent: :destroy

  accepts_nested_attributes_for :student_age_brackets
  accepts_nested_attributes_for :detail

  delegate :student_filters, :logo, to: :student_product

  #Scopes
  generate_scopes
  scope :active, -> {status_eq(true)}
  scope :with_type, ->(type) {detail_type_eq(type).active}
  scope :family, -> {detail_type_eq("StudentFamilyDetail")}
  scope :couple, -> {detail_type_eq("StudentCoupleDetail")}
  scope :single, -> {detail_type_eq("StudentSingleDetail")}

  validates :student_product_id, presence: true

  delegate :has_special_rate?, to: :detail

  def get_rates(age, sum)
    student_age_brackets.merge(StudentAgeBracket.include_age(age)).joins(:rates).merge(StudentRate.include_sum(sum)).select("student_rates.rate as rate")
  end

  #This is a fix for destroy related agebrackets for the plans that are not
  #tied to other plans. 
  def destroy_related
    destroyable_ages = []
    age_bracket_ids = self.student_age_brackets.pluck(:id)
      age_bracket_ids.each do |id|
        agesets = StudentAgeSet.where(student_age_bracket_id: id)
        if agesets.any? && agesets.count == 1
          destroyable_ages << agesets
        end
      end
      
    destroyable_ages.each do |age| 
      age.first.student_age_bracket.destroy
    end
    self.destroy 
  end

  def detail_type
    super.gsub("Detail", "").gsub("Student", "") if super
  end

  self.inheritance_column = :race 

  #Adding agebracket to family and couple version automatically if no special rate is specified
  def add_age_bracket
    unless self.has_special_rate?
      single_version = self.student_product.student_versions.where(:detail_type => "StudentSingleDetail")
      if single_version.any?
        age_bracket_ids = StudentAgeSet.where(:student_version_id => single_version.first.id).pluck(:student_age_bracket_id).map { |i| {:student_age_bracket_id => i }}
        if age_bracket_ids.any?
          StudentAgeSet.create(age_bracket_ids) do |a|
            a.student_version_id = self.id
          end
        end
      end
    end
  end

end
