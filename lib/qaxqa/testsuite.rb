require "qaxqa/testcase"
module Qaxqa
	
	# Module class to set XML parsed attributes
	class Testsuite

		attr_accessor :testcases

		def fetch!(path)
			require 'nokogiri'
			doc = Nokogiri::XML(File.open(path))
			self.testcases = []
			doc.xpath("//testcase").each do |tc|
				self.testcases << Testcase.new(tc)
			end

		end

	end

end

