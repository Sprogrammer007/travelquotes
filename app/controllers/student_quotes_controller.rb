class StudentQuotesController < ApplicationController

 
  def new
    @quote = StudentQuote.new
    @quote.student_traveler_members.new
  end 


  def create
    @quote = StudentQuote.new(permitted_params)
    if @quote.complete
      redirect_to student_quote_path(@quote, :student_quote_id => @quote.quote_id)
    else
      render  :action => "new", :quote_type => "Visitor"
    end
  end

  def show
    @quote = StudentQuote.find(params[:id] || params[:student_quote_id])
    # if params[:deductible] && @quote
    #   @quote.update(deductible_filter: params[:deductible])
    # end

    if @quote
      @quote.search
    end

    # if @quote.product_filters.any? || @quote.deductible_filter
    #   @quote.filter_results
    # end

    Rails.cache.fetch([@quote.class.name, @quote.id]) { @quote }
  end

  def apply_filters
    @quote = Rails.cache.fetch([Quote.name, params[:id]]) { Quote.find(params[:id]) }

    if params[:filter_id] && @quote.not_include_filter?(params[:filter_id])
      AppliedFilter.create(product_filter_id: params[:filter_id]) do |a|
        a.quote_id = params[:id]
      end

      @quote.filter_results
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def remove_filters
    id = params[:id]
    @quote = Rails.cache.fetch([Quote.name, id]) { Quote.find(id) }

    AppliedFilter.where(product_filter_id: params[:filter_id], quote_id: id).delete_all
    @quote.filter_results
    respond_to do |format|
      format.html { render "show" }
      format.js
    end
  end

  def compare
    @quote = Quote.find(params[:quote_id])
    @products = Product.find_compare(params[:products])
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def compare_legals
    @products = Product.find(params[:products].split(",").map(&:to_i)).sort_by!{ |p| p.id }
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def detail
    @product = Product.find(params[:product_id])
    @age = params[:t_age]
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def email
    @quote = Quote.find(params[:id])
      
    if @quote
      QuoteMailer.email_quote_id(@quote).deliver
      
      respond_to do |format|
        format.html { redirect_to root_path}
        format.js
      end
    end
  end
  
  def update_email
    @quote = Quote.find(params[:id])
    @quote.update(:email => params[:email])
    respond_to do |format|
      format.html { redirect_to :back}
      format.js
    end
  end
  private

    def permitted_filters
      params.permit(:filters => [:product_filter_id])
    end

    def permitted_params
      params.require(:student_quote).permit(:leave_home, :return_home, :traveler_type, :has_preex, :email, :plan_type
        :student_traveler_members_attributes => [:member_type, :gender, :birthday]).merge(:client_ip => request.remote_ip)
    end
end
