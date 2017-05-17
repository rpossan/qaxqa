module Qaxqa
	
	# Module class to set XML parsed attributes to a suitecase object
	class Testsuite

		attr_accessor :subject, :test_name, :details, :testcases

		def self.parse(doc)
			root = doc.xpath("//testsuite/testsuite")
			main_subject = root.first.attributes["name"].value
			suites = []
			root.each do |node|
				unless node.attributes["name"].nil?
					suite = Testsuite.new
					suite.subject = main_subject
					suite.test_name = node.attributes["name"].value
					suite.details = node.xpath("./details").text
					suite.testcases = []
					node.children.xpath("./testcase").each do |tc|
						testcase = Testcase.new
						testcase.subject = suite.subject
						testcase.test_name = tc.attributes["name"].value
						testcase.summary = tc.xpath("./summary").text
						testcase.preconditions = tc.xpath("./preconditions").text
						suite.testcases << testcase
					end
					suites << suite
				end
			end
			return suites
		end

		private

	end

end