require "qaxqa/testcase"
require "qaxqa/testsuite"
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
			@doc.xpath("//testsuite/testsuite/testsuite").each do |suite|
				@testsuites << Testsuite.new(suite)
			end
		end

	end

end

