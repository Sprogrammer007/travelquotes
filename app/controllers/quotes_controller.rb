class QuotesController < ApplicationController

	def create
		@c = Plan.all
		Rails.cache.write(:params, params)
		Rails.cache.write(:results, @c)
		redirect_to  result_quotes_path
	end

	def result
		@p = Rails.cache.read(:params)
		@results = Rails.cache.read(:results)
	end
end
