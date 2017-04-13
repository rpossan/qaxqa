require 'thor'

module Qaxqa
  class CommandsInterface < Thor
    desc "migrate INPUT", "Migrate folder or XML file to spreadsheet format"
    long_desc <<-HELLO_WORLD

    `migrate INPUT` Migrate a file or folder with XML files exported from TesLink to spreadsheet HP Quality Center format.
    
    HELLO_WORLD
    option :format
    def migrate(input)
      
    end
  end
end