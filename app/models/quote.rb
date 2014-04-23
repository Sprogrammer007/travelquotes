class Quote

	def self.getFilters
		{
			"Cancellation" => %w{Trip\ Interruption Hurricane\ &\ Weather Terrorism Financial\ Default Employment\ Layoff Cancel\ For\ Work\ Reasons Cancel\ For\ Any\ Reason},
			"Medical" => %w{Primary\ Medical Emergency\ Medical Pre-existing\ Medical Medical\ Deductible},
			"Loss or Delay" => %w{Travel\ Delay Baggage\ Delay Baggage\ Loss Missed\ Connection},
			"Life Insurance" => %w{Accidental\ Death Air\ Flight\ Accident Common\ Carrier}
		}
	end
end