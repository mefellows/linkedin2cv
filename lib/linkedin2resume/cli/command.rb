require 'linkedin2resume/version'
require 'linkedin2resume/logging'
require 'linkedin2resume/converter'
require 'clamp'

module Linkedin2Resume
  class AbstractCommand < Clamp::Command
    include Logging

    option ["-v", "--verbose"], :flag, "be verbose"
    option "--version", :flag, "show version" do
      puts "Linkedin2Resume v" + Linkedin2Resume::VERSION
      exit(0)
    end

  end

  class ConvertCommand < AbstractCommand
      option "--format", "format", "Specify the output format. Options are [pdf, asciidoc, latex, odf]", :attribute_name => :format, :default => 'asciidoc'
      option "--options", "options", "Specify an options file with supplemental data and settings", :attribute_name => :options_file
      option "--style", "style", "Specify the style resume you want. Options are [standard, awesome, boring] ", :attribute_name => :format, :default => 'standard'
      option "--all-fields", :flag, "Import all supported LinkedIn fields [position, company, publication, patent, language, skills, certification, education, course, volunteer, recommendations]", :attribute_name => :all
      option "--position", :flag, "Import Position Profile data", :default => true
      option "--company", :flag, "Import Company Profile data", :default => true
      option "--skills", :flag, "Import Skills Profile data", :default => true

      option "--max-skills", "depth", "Level of depth to recurse", :attribute_name => :max_skills, :default => 10 do |s|
        Integer(s)
      end

      parameter "[output_file]", "Output file", :attribute_name => :output_file

    def execute
      converter = Linkedin2Resume::Converter.new
      options = YAML.load_file(options_file)
      converter.create_resume(options)
    end
  end

  class MainCommand < AbstractCommand
    subcommand "convert", "Magically converts your LinkedIn Profile to a professional resume", Linkedin2Resume::ConvertCommand
  end
end