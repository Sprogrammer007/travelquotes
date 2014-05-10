class QuotesController < ApplicationController

	def new
		@quote = Quote.new
		@quote.traveler_members.new
	end

	def create
		@quote = Quote.new(permitted_params)
		@quote.save
		redirect_to quote_path(@quote, :quote_id => @quote.quote_id)
	end

	def show
		@quote = Quote.find(params[:id])
		if @quote
			@quote.search
		end

		if @quote.product_filters.any?
			@quote.filter_results
		end
		return @quote
	end

	def apply_filters
				Rails.logger.warn "#{@quote}"
		if params[:filters]
			AppliedFilter.create(permitted_filters[:filters]) do |a|
				a.quote_id = params[:quote_id]
			end
		end
		redirect_to :back
	end

	def remove_filters

		AppliedFilter.where(product_filter_id: params[:id], quote_id: params[:quote_id]).delete_all
		redirect_to :back
	end

	private

		def permitted_filters
			params.permit(:filters => [:product_filter_id])
		end
		def permitted_params
			params[:quote][:sum_insured] = params[:quote][:sum_insured].gsub(",", "").to_i
			params.require(:quote).permit(:leave_home, :return_home, :apply_from, :arrival_date,
				:arrival_date, :trip_cost, :sum_insured, :traveler_type, :has_preex,
				:traveler_members_attributes => [:member_type, :gender, :birthday]).merge(:client_ip => request.remote_ip)
		end
end
