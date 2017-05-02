module Qaxqa
	
	# Module class to set XML parsed attributes to a suitecase object
	class Testsuite

		attr_accessor :subject, :test_name

		def initialize(doc = nil)
			parse! doc unless doc.nil?
		end

		private

		def parse!(doc)
			@subject = doc.xpath("//testsuite/testsuite").first.attributes["name"].value
		end

	end

end