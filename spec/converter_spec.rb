require 'rspec'
require 'linkedin2cv/cli/command'
require 'linkedin2cv/converter'
require 'spec_helper'
require 'linkedin-oauth2'

describe Linkedin2CV::Converter do

  before do
    @client = Linkedin2CV::Converter.new
    @profile = @client.get_profile
    @config = YAML.load_file(__dir__ + "/mocks/config.yml")

  end

  it 'Should Fetch skills' do
    # puts @profile.member_url_resources
    # @profile.skills.all.map do |skill|
    #   puts skill.skill.name
    # end

    # Should get back a Mash of objects
    expect(@profile.skills).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch education' do
    expect(@profile.educations).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch associations' do
    expect(@profile.associations).to be_an_instance_of(String)
  end

  it 'Should Fetch interests' do
    expect(@profile.interests).to be_an_instance_of(String)
  end

  it 'Should Fetch recommendations' do
    expect(@profile.recommendations_received).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch jobs' do
    expect(@profile.job_bookmarks).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch current jobs' do
    expect(@profile.three_current_positions).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch past jobs' do
    expect(@profile.three_past_positions).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch URLs' do
    expect(@profile.member_url_resources).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should compile latex on the CLI' do

  end


  it 'Should create a latex Resume' do
    @client.create_resume(@config)

    # @config['skills']['extra'].each do |k|
    #   # puts k
    #   k.keys.each do |category|
    #     k[category].each do |v|
    #       puts v
    #     end
    #   end
    # end

  end

  it 'Should monkey patch the ERB Compiler to escape LaTeX special chars' do
    # puts ERB.new('<%=@profile.location.name %>')
    replaced = ERB.new("<%= 'this & interesting' %><%= 'I have lots of $$ which is >= Bill Gates but < some Middle Eastern oil tychoons ~ net % of the detail' %>").result
    expect(replaced).to eql('this \& interestingI have lots of \$\$ which is \textgreater= Bill Gates but \textless some Middle Eastern oil tychoons \textasciitilde net \% of the detail')
  end

end