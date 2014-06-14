module Linkedin2CV
  class LatexRenderer

    # Public: Produce a Latex PDF
    #
    #
    def latex_pdf(profile, options)

      def clean_latex(s)
        # Clean &
        s = s.gsub(/(?<!\\)\&(?!\\)/, '\\\&')

        # Clean $
        s = s.gsub(/(?<!\\)\$(?!\\)/, '\\\$')

        # Clean %
        s = s.gsub(/(?<!\\)%(?!\\)/, '\\\%')

        # # Clean ~
        s = s.gsub(/\~/, '\\\textasciitilde')

        # # Clean >
        s = s.gsub(/\>/, '\\\textgreater')

        # # Clean <
        s = s.gsub(/\</, '\\\textless')

        s
      end

      require 'tilt/erb'
      output_filename = "#{options['output_file']}.latex"
      template = Tilt.new('templates/cv.erb')

      output = template.render(self, :profile => profile, :options => options)

      output_file = File.new(output_filename, 'w')
      output_file.write(output)
      output_file.close

      # Make sure this variable is escaped, clearly.....
      exec("pdflatex #{output_filename}")
    end

    # Public: Produce a Latex
    #
    #
    def latex

    end
  end
end

# Monkey patching jiggery-pokery to escape special LaTeX chars
# automatically from ERB <%= %> statements
class ERB::Compiler
  alias_method :old_add_insert_cmd, :add_insert_cmd
  alias_method :old_add_put_cmd, :add_put_cmd

  def add_insert_cmd(out, content)
    out.push("#{@insert_cmd}(clean_latex( (#{content}).to_s ))")
  end

end
