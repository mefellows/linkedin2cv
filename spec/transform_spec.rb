require 'rspec'
require 'linkedin2resume/commands/linkedin2resume'
require 'linkedin2resume/filters/transformers'
require 'spec_helper'

url = URI::parse('http://foo.com/foo/bar')

describe Transformers::Util do
  it 'Should remove #fragments URIs' do
    transformers = Transformers::Util.get_all_transformers

    index = Hash.new
    index['http://foo.com'] = ""
    index['http://foo.com/#fragment'] = ""
    index['http://foo.com/#!/hash-bang/fragment'] = ""
    index['http://foo.com/#'] = ""
    index['http://foo.com/foo'] = ""
    index['http://foo.com/foo?'] = ""
    index['http://foo.com/foo?foo'] = ""
    index['http://foo.com/foo?foo=bar'] = ""
    index['http://foo.com/foo.pdf'] = ""
    index['http://foo.com/bar'] = ""
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

    i = Transformers::Util.apply_transformers(index, transformers)

    expect(i.length).to eq 25
    i.each  do |k,v|
      expect(k.to_s.match('\?')).to eq nil
    end
  end
end