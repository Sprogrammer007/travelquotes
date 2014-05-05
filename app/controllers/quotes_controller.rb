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
		@quote = Quote.find_by(:quote_id => params[:quote_id])
		if @quote
			@quote.search
		end
	end

	def couple
		@quote = Quote.find(params[:id])
		@results = @quote.single_search(@quote.get_ages["Adult"][params[:traveler_number] - 1])
		respond_to do |format|
      format.js
    end
	end

	private

		def permitted_params
			params[:quote][:sum_insured] = params[:quote][:sum_insured].gsub(",", "").to_i
			params.require(:quote).permit(:leave_home, :return_home, :apply_from, :arrival_date,
				:arrival_date, :trip_cost, :sum_insured, :traveler_type, 
				:traveler_members_attributes => [:member_type, :gender, :birthday]).merge(:client_ip => request.remote_ip)
		end
end
