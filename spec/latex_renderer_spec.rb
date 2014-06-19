require 'rspec'
require 'linkedin2cv/cli/command'
require 'linkedin2cv/converter'
require 'linkedin2cv/renderer/latex_renderer'
require 'spec_helper'
require 'linkedin-oauth2'

describe Linkedin2CV::LatexRenderer do

  before do
    @client = Linkedin2CV::Converter.new
    @profile = @client.get_profile
    @config = YAML.load_file(__dir__ + "/mocks/config.yml")
    @latex_spec = File.read(__dir__ + "/mocks/matt.latex")
  end

  it 'Should create a latex Resume' do
    @client.create_resume(@config)
  end

  it 'Should return a working LaTeX document' do
    renderer = Linkedin2CV::LatexRenderer.new
    output = renderer.render_latex(@profile, @config)
    # expect(output).to eql(@latex_spec)
  end

  it 'Should monkey patch the ERB Compiler to escape LaTeX special chars' do
    replaced = ERB.new("<%= 'this & interesting' %><%= 'I have lots of $$ which is >= Bill Gates but < some Middle Eastern oil tychoons ~ net % of the detail' %>").result
    expect(replaced).to eql('this \& interestingI have lots of \$\$ which is \textgreater= Bill Gates but \textless some Middle Eastern oil tychoons \textasciitilde net \% of the detail')
  end

end