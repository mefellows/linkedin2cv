require 'linkedin2cv/version'
require 'linkedin2cv/logging'
require 'linkedin2cv/converter'
require 'clamp'

module Linkedin2CV
  class AbstractCommand < Clamp::Command
    include Logging

    option ["-v", "--verbose"], :flag, "be verbose"
    option "--version", :flag, "show version" do
      puts "Linkedin2CV v" + Linkedin2CV::VERSION
      exit(0)
    end

  end

  class ConvertCommand < AbstractCommand
      option "--format", "format", "Specify the output format. Options are [asciidoc, latex (pdf)]", :attribute_name => :format, :default => 'latex'
      option "--options", "options", "Specify an options file with supplemental data and settings", :attribute_name => :options_file
      # option "--style", "style", "Specify the style resume you want. Options are [standard, awesome, boring] ", :attribute_name => :format, :default => 'standard'
      # option "--all-fields", :flag, "Import all supported LinkedIn fields [position, company, publication, patent, language, skills, certification, education, course, volunteer, recommendations]", :attribute_name => :all
      # option "--position", :flag, "Import Position Profile data", :default => true
      # option "--company", :flag, "Import Company Profile data", :default => true
      # option "--skills", :flag, "Import Skills Profile data", :default => true

      parameter "[output-file]", "Output file (without extension. e.g. 'output' to produce 'output.pdf', 'output.latex'", :attribute_name => :output_file, :default => 'output'

    def execute
      options = {}
      if !options_file.nil?
        options = YAML.load_file(options_file)
      end

      options['output_file'] = output_file
      options['format'] = format

      converter = Linkedin2CV::Converter.new
      converter.create_resume(options)
    end
  end

  class MainCommand < AbstractCommand
    subcommand "convert", "Magically converts your LinkedIn Profile to a professional resume", Linkedin2CV::ConvertCommand
  end
end