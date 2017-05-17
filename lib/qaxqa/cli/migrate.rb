require 'byebug'
require 'qaxqa/all_suite'
module Qaxqa
    # Migrate given xml files and outputs to XLS HP Quality Center format
    class CLI::Migrate

        def run(input)
            validate_param input
            require 'rubyXL'
            files = supported_files_from input
            files.each { |f| convert_entities f; to_hpqc f }
        end

        private

        def to_hpqc(file)
            suites = extract file
            workbook = RubyXL::Workbook.new
            worksheet = workbook.worksheets[0]
            set_header worksheet
            line = 0
            suites.testsuites.each_with_index do |s, idx|
                line += 1
                worksheet.add_cell(line, 0, s.subject)
                worksheet.add_cell(line, 1, s.test_name)
                worksheet.add_cell(line, 2, s.details)
                s.testcases.each_with_index do |tc, tc_idx|
                    line += 1
                    worksheet.add_cell(line, 0, tc.subject)
                    worksheet.add_cell(line, 1, tc.test_name)
                    worksheet.add_cell(line, 2, tc.summary)
                    worksheet.add_cell(line, 3, tc.preconditions)
                end
            end

            workbook.write("output.xlsx")
        end

        def extract(xml)
            AllSuite.new(xml)
        end

        def set_header(ws)
            ws.add_cell(0, 0, "Subject")
            ws.add_cell(0, 1, "Test Name")
            ws.add_cell(0, 2, "Description")
            ws.add_cell(0, 3, "preconditions")
            ws.add_cell(0, 4, "step_number")
            ws.add_cell(0, 5, "actions")
            ws.add_cell(0, 6, "expectedresults")
            ws.add_cell(0, 7, "Type")
            ws.sheet_data[0][0].change_font_bold(true)
            ws.sheet_data[0][1].change_font_bold(true)
            ws.sheet_data[0][2].change_font_bold(true)
            ws.sheet_data[0][3].change_font_bold(true)
            ws.sheet_data[0][4].change_font_bold(true)
            ws.sheet_data[0][5].change_font_bold(true)
            ws.sheet_data[0][6].change_font_bold(true)
            ws.sheet_data[0][7].change_font_bold(true)
            ws.change_column_width(0, 50)
            ws.change_column_width(1, 70)
            ws.change_column_width(2, 70)
            ws.change_column_width(3, 70)
            ws.change_column_width(4, 70)
            ws.change_column_width(5, 70)
            ws.change_column_width(6, 70)
            ws.change_column_width(7, 70)
        end

        def convert_entities(path)
            require 'htmlentities'
            content = File.read(path)
            content = HTMLEntities.new.decode content
            File.open(path, "w") { |f| f.write content }
        end

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
        end

        def file_or_dir_present?(p)
            File.directory?(p) || File.exist?(p)
        end
    end
end