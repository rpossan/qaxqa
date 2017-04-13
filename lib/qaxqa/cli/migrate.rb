require 'byebug'
module Qaxqa
	# Migrate given xml files and outputs to XLS HP Quality Center format
	class CLI::Migrate

    	def run(input)
    		validate_param input
    		files = supported_files_from input
    	end

    	private
    	def supported_files_from(input)
    		supported_files = []
    		if File.directory?(input)
    			supported_files = Dir["#{input}*"]
			else
				supported_files << input
			end

			supported_files.delete_if{ |f| !is_xml?(f) }
			raise 	"There is no file with supported format (XML)!\n"\
					"Check the param, file or folder path and try again." if supported_files.empty?
			return supported_files
		end

		def is_xml?(f)
			File.extname(f) == ".xml"
		end

    	def validate_param(input)
    		fail "File or directory does not exists!" unless file_or_dir_present? input
    		true
		end

		def file_or_dir_present?(p)
			File.directory?(p) || File.exists?(p)
		end

  	end
end