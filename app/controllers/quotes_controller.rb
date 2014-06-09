class QuotesController < ApplicationController

	def new
		@quote = Quote.new
		@quote.traveler_members.new
	end

	def create
		@quote = Quote.new(permitted_params)
		if @quote.complete
			redirect_to quote_path(@quote, :quote_id => @quote.quote_id)
		else
			render  :action => "new", :quote_type => "Visitor"
		end
	end

	def show
		@quote = Quote.find(params[:id] || params[:quote_id])
		if params[:deductible] && @quote
			@quote.update(deductible_filter: params[:deductible])
		end

		if @quote
			@quote.search
		end

		if @quote.product_filters.any? || @quote.deductible_filter
			@quote.filter_results
		end

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
		@products = Product.find_compare(params[:products])
		respond_to do |format|
    	format.html { redirect_to root_path}
    	format.js
    end
	end

	def detail
		@product = Product.find(params[:product_id])
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
			params[:quote][:sum_insured] = params[:quote][:sum_insured].gsub(",", "").to_i
			params.require(:quote).permit(:leave_home, :return_home, :apply_from, :arrival_date,
				:arrival_date, :trip_cost, :sum_insured, :traveler_type, :has_preex, :quote_type, :renew, :email,
				:traveler_members_attributes => [:member_type, :gender, :birthday]).merge(:client_ip => request.remote_ip)
		end
end
