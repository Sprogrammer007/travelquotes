module ActiveAdmin
	module Views
		class MyIndex < ActiveAdmin::Views::IndexAsTable

			def self.index_name
				"my_idea"
			end

		end
	end
end