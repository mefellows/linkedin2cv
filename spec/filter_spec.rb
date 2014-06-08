require 'rspec'
require 'linkedin-to-resume/commands/linkedin-to-resume'
require 'linkedin-to-resume/filters/filters'
require 'spec_helper'

url = URI::parse('http://foo.com/foo/bar')

describe Filters::LocalFilter do


  it 'Should exclude non-local URIs' do
    filter = Filters::LocalFilter.new
    filter.is_link_local?('http://www.foo.com/something', url).should eq(false)
    filter.is_link_local?('https://www.foo.com/something', url).should eq(false)
    filter.is_link_local?('http://www.somethingelse.com/something', url).should eq(false)
    filter.is_link_local?('https://www.somethingelse.com/something', url).should eq(false)

    expect(filter.filter(Hash.new, 'https://www.somethingelse.com/something', 'https://foo.com/')).to eq(false)
  end

  it 'Should exclude javascript links' do
    filter = Filters::LocalFilter.new
    # This is a valid case for THIS method, may choose to exclude elsewhere in the program
    # filter.is_link_local?('#thisisareallylonganchorname', url).should eq(false)
    filter.is_link_local?('alert(\'true\')', url).should eq(false)

    expect(filter.filter(Hash.new, 'alert(\'true\')', 'https://foo.com/')).to eq(false)
  end

  it 'Should include relative URIs' do
    filter = Filters::LocalFilter.new
    filter.is_link_local?('/something', url).should eq(true)
    filter.is_link_local?('/', url).should eq(true)

    expect(filter.filter(Hash.new, '/something', url)).to eq(true)

  end

  it 'Should include absolute local URIs' do
    filter = Filters::LocalFilter.new
    filter.is_link_local?('http://foo.com', url).should eq(true)
    filter.is_link_local?('http://foo.com/foo/bar', url).should eq(true)
    filter.is_link_local?('http://foo.com/something', url).should eq(true)
    filter.is_link_local?('https://foo.com/something', url).should eq(true)

    filter.filter(Hash.new, 'http://foo.com', url).should eq(true)
    filter.filter(Hash.new, 'http://foo.com/foo/bar', url).should eq(true)
    filter.filter(Hash.new, 'http://foo.com/something', url).should eq(true)
    filter.filter(Hash.new, 'https://foo.com/something', url).should eq(true)

    filter.filter(Hash.new, URI::parse('http://foo.com'), url).should eq(true)
    filter.filter(Hash.new, URI::parse('http://foo.com/foo/bar'), url).should eq(true)
    filter.filter(Hash.new, URI::parse('http://foo.com/something'), url).should eq(true)
    filter.filter(Hash.new, URI::parse('https://foo.com/something'), url).should eq(true)

  end
end

describe Filters::ResourcesFilter do
  it 'Should exclude static resources' do
    filter = Filters::ResourcesFilter.new
    filter.filter(Hash.new, 'http://www.foo.com/something.pdf', 'http://www.foo.com/').should eq(false)
    filter.filter(Hash.new, 'http://www.foo.com/something.txt', 'http://www.foo.com/').should eq(false)
    filter.filter(Hash.new, 'http://www.foo.com/something./', 'http://www.foo.com/').should eq(true)
    filter.filter(Hash.new, 'http://www.foo.com/something-/', 'http://www.foo.com/').should eq(true)
    filter.filter(Hash.new, 'http://www.foo.com/something-bar/-cake-', 'http://www.foo.com/').should eq(true)
    filter.filter(Hash.new, 'http://www.foo.com/something-bar/-cake-/', 'http://www.foo.com/').should eq(true)
    filter.filter(Hash.new, 'http://www.foo.com', 'http://www.foo.com/').should eq(true)
  end

  it 'Should allow valid URIs' do
    filter = Filters::ResourcesFilter.new
    filter.filter(Hash.new, 'http://www.foo.com', 'http://www.foo.com/').should eq(true)
  end

  it 'Should not allow links to be indexed more than once' do
    filter = Filters::LocalFilter.new

    index = Hash.new
    index['http://www.webcentral.com.au'] = {"title" => "cheese"}
    expect(filter.should_index_local_link?(Filters::Util.create_absolute_uri('http://www.webcentral.com.au', 'http://www.webcentral.com.au'), index, 'http://www.webcentral.com.au')).to eq false
  end

  it 'Should return a filtered Hash' do
    filters = Filters::Util.get_all_filters
    # filters = [Filters::ResourcesFilter.new]

    index = Hash.new
    index['http://foo.com'] = ""
    index['http://foo.com/foo'] = ""
    index['http://foo.com/foo.pdf'] = ""
    index['http://foo.com/bar'] = ""
    index['http://foo.com/bar#'] = ""
    index['http://foo.com/bar/#'] = ""
    index['http://foo.com/bar/#foo'] = ""
    index['http://foo.com/bar/#!/hashbang/foo'] = ""
    index['http://foo.com/bar.tar.gz'] = ""
    index['http://bar.com/foo'] = ""
    index['http://www.mootools.net/'] = ""
    index['http://www.wordpress.org'] = ""
    index['http://www.blueprintcss.com'] = ""
    index['http://www.php.net'] = ""
    index['/contact'] = ""
    index['http://www.onegeek.com.au'] = ""
    index['http://h2vx.com/vcf/http://development.onegeek.com.au/contact/'] = ""
    index['http://www.cloudflare.com/email-protection#d4b9b5a0a0fab2b1b8b8bba3a794bbbab1b3b1b1bffab7bbb9fab5a1'] = ""
    index['http://www.twitter.com/matthewfellows'] = ""
    index['http://au.linkedin.com/pub/matt-fellows/4/153/656'] = ""
    index['http://www.flickr.com/photos/mattfellows'] = ""
    index['http://www.delicious.com/mefellows'] = ""
    index['/_assets/faqs/pdf/managed-exchange/Exchange - Recovering Deleted Items.pdf'] = ""

    i = Filters::Util.apply_filters(index, Hash.new, url, filters)
    puts i

    expect(i.length).to eq 4

  end

  it 'Should return an empty filtered Hash' do
    filters = Filters::Util.get_all_filters

    index = Hash.new
    index['http://bar.com/foo'] = ""

    i = Filters::Util.apply_filters(index, Hash.new, url, filters)
    puts i

    # Need to prevent mutation in filtering
    expect(filters.length).to eq 4

    expect(i.length).to eq 0

  end

  it 'Should return the a Hash containing the initial URI' do
    filters = Filters::Util.get_all_filters

    i = Filters::Util.apply_filters([url], Hash.new, url, filters)
    puts i

    expect(i.length).to eq 1

  end
end

describe Filters::Util do
  it 'Should return an absolute URI' do
    expect(Filters::Util.create_absolute_uri('/', url).to_s).to eq 'http://foo.com/'
  end
end