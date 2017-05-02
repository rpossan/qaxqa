module Qaxqa
	
	# Module class to set XML parsed attributes to a testcase object
	class Testcase

		attr_accessor :name

		def initialize(doc = nil)
			parse! doc unless doc.nil?
		end

		private

		def parse!(doc)
			self.name = doc.attributes["name"].value
		end

	end

end
