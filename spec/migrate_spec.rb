require "spec_helper"

describe Qaxqa::CLI::Migrate do
	describe "#run" do
		context "without param"
		it "should raise an argment error" do
			expect { Qaxqa::CLI::Migrate.new.run }.to raise_error ArgumentError
		end
	end
end