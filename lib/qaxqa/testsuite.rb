module Qaxqa
	
	# Module class to set XML parsed attributes to a suitecase object
	class Testsuite

		attr_accessor :subject, :test_name, :details, :testcases, :testsuites

		def self.has_suite?(node)
			node.xpath('./testsuite').size > 0
		end

		# Parse testcases
		def self.parse_testcases(testsuite)
			testcases = []
			testsuite.xpath("./testcase").each do |tc|
				testcase = Testcase.new
				testcase.steps = []
				testcase.subject = suite.subject
				testcase.test_name = tc.attributes["name"].value
				testcase.summary = tc.xpath("./summary").text
				testcase.preconditions = tc.xpath("./preconditions").text
				testcase.test_type = "Manual"
				# Parse steps
				tc.xpath("./steps/*").each do |step_node|
					step = Step.new
					step.step_number = step_node.xpath("./step_number").text
					step.actions = step_node.xpath("./actions").text
					step.expectedresults = step_node.xpath("./expectedresults").text
					testcase.steps << step
				end
				testcases << testcase
			end
			return testcases
		end

		def self.parse(doc)
			root = doc.xpath("//testsuite/testsuite")
			main_subject = root.first.attributes["name"].value
			suites = []
			# Parse suites
			root.each do |node|
				unless node.attributes["name"].nil?
					suite = Testsuite.new
					suite.subject = main_subject
					suite.test_name = node.attributes["name"].value
					suite.details = node.xpath("./details").text
					suite.testcases = self.parse_testcases node
					suite.testsuites = []

					if self.has_suite? node
						subnode = node.xpath("./testsuite")
						subnode.each do |sn|
							subsuite = Testsuite.new
							subsuite.subject = main_subject
							subsuite.test_name = sn.attributes["name"].value
							subsuite.details = sn.xpath("./details").text
							subsuite.testcases = self.parse_testcases sn
							subsuite.testsuites = []
							suite.testsuites << subsuite
						end
					end
					suites << suite
				end
			end
			return suites
		end

	end

end