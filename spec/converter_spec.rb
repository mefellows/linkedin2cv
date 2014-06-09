require 'rspec'
require 'linkedin2resume/cli/command'
require 'linkedin2resume/converter'
require 'spec_helper'
require 'linkedin-oauth2'

describe Linkedin2Resume::Converter do

  before do
    @client = Linkedin2Resume::Converter.new
    @profile = @client.get_profile
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

    @profile.three_current_positions.all.map do |k|
      puts k.company.name
    end
  end

  it 'Should Fetch past jobs' do
    puts @profile.three_current_positions.all.concat(@profile.three_past_positions.all)
    expect(@profile.three_past_positions).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should Fetch URLs' do
    expect(@profile.member_url_resources).to be_an_instance_of(LinkedIn::Mash)
  end

  it 'Should compile latex on the CLI' do
    str1 = "foo bar & "
    str = str1.sub(/(?<!\\)&/, '\\\&')
    puts str
    expect(str).to eql("foo bar \\\& ")

        foo = [{
            "id"=>69,
            "skill"=>{"name"=>"Change Management"}
        },
        {
            "id"=>70,
            "skill"=>{"name"=>"conversion rate optimization"}
        },
        {
            "id"=>71,
            "skill"=>{"name"=>"Agile Methodologies"}
        },
        {
            "id"=>72,
            "skill"=>{"name"=>"Web Development"}
        },
        {
            "id"=>73,
            "skill"=>{"name"=>"APIs"}
        },
        {
            "id"=>74,
            "skill"=>{"name"=>"E-commerce"}
        },
        {
            "id"=>75,
            "skill"=>{"name"=>"HTML 5"}
        },
        {
            "id"=>76,
            "skill"=>{"name"=>"Web Applications"}
        },
        {
            "id"=>77,
            "skill"=>{"name"=>"Agile Project Management"}
        }]

    # items = foo.map do |item|
    #   "\textsc{#{item['skill']['name']}"
    # end
    items = foo.map do |item|
      "\textsc{#{item['skill']['name']}"
    end
    puts items.join(', ')
  end


  it 'Should create a latex Resume' do
    @client.create_resume
  end
end