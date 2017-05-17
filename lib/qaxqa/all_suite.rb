require "qaxqa/testcase"
require "qaxqa/testsuite"
require "qaxqa/step"

module Qaxqa
	
	# Module class to set XML parsed attributes
	class AllSuite

		attr_accessor :testsuites, :doc

		def initialize(path = nil)
			@testsuites = []
			@doc = nil
			fetch! path unless path.nil?
		end

		private

		def fetch!(path)
			require 'nokogiri'
			@doc = Nokogiri::XML(File.open(path))

			@testsuites = Testsuite.parse(@doc)
		end

	end

end

