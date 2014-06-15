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
end