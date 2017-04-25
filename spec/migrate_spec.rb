require "spec_helper"

describe Qaxqa::CLI::Migrate do
	let(:migrate_cmd) { Qaxqa::CLI::Migrate.new }
	let(:valid_folder_path) { "spec/" }
	let(:valid_file_path) { "all_testsuites.xml" }

	describe "#run" do
		context "without param" do
			it "should raise an argument error" do
				expect { migrate_cmd.run }.to raise_error ArgumentError
			end
		end

		context "with invalid path" do
			it "should raise an runtime error" do
				expect { migrate_cmd.run "" }.to raise_error RuntimeError
			end
		end

		context "with a valid file path" do
			it "should process and return true" do
				expect(migrate_cmd.run(valid_folder_path + valid_file_path)).to be_truthy
			end
		end

		context "with a valid folder path" do
			it "should process and return true" do
				expect(migrate_cmd.run valid_folder_path).to be_truthy
			end
		end

		context "with a valid folder path" do
			it "should proccess and convert xml and outputs to a valid XLS input" do
				expect(migrate_cmd.run valid_folder_path).to be_truthy
			end
		end

	end

end