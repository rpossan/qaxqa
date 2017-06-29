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

        def insert_cases(ws, cases, line)
            cases.each_with_index do |tc|
                start_line = line + 1
                tc.steps.each_with_index do |step|
                    line +=1
                    ws.add_cell(line, 0, tc.subject)
                    ws.add_cell(line, 1, tc.test_name)
                    ws.add_cell(line, 2, tc.summary)
                    ws.add_cell(line, 3, tc.preconditions)
                    ws.add_cell(line, 4, step.step_number)
                    ws.add_cell(line, 5, step.actions)
                    ws.add_cell(line, 6, step.expectedresults)
                    ws.add_cell(line, 7, tc.test_type)
                end
                ws.merge_cells(start_line, 0, line, 0)
                ws.merge_cells(start_line, 1, line, 1)
                ws.merge_cells(start_line, 2, line, 2)
                ws.merge_cells(start_line, 3, line, 3)
                ws.merge_cells(start_line, 7, line, 7)
            end
            return line
        end

        def to_hpqc(file)
            suites = extract file
            workbook = RubyXL::Workbook.new
            worksheet = workbook.worksheets[0]
            set_header worksheet
            line = 0
            suites.testsuites.each_with_index do |s|
                subject_name = s.subject
                line += 1
                if s.testsuites.size > 0
                    s.testsuites.each do |ss|
                        worksheet.add_cell(line, 0, subject_name)
                        worksheet.add_cell(line, 1, ss.test_name)
                        worksheet.add_cell(line, 2, ss.details)
                        line = insert_cases(worksheet, ss.testcases, line) if ss.testcases.size > 0
                    end
                end
                worksheet.add_cell(line, 0, subject_name)
                worksheet.add_cell(line, 1, s.test_name)
                worksheet.add_cell(line, 2, s.details)
                line = insert_cases(worksheet, s.testcases, line) if s.testcases.size > 0
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