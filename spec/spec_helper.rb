require 'rspec'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    response_mock = File.read(__dir__ + "/mocks/profile.json")

    stub_request(:get, /.*api.linkedin.com.*/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: response_mock, headers: {})

    stub_request(:get, "https://api.linkedin.com/v1/people/~:(main-address,phone-numbers,email-address,first-name,last-name,maiden-name,formatted-name,phonetic-first-name,phonetic-last-name,formatted-phonetic-name,headline,location:(name),location:(country:(code)),industry,current-status,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,site-standard-profile-request,api-standard-profile-request:(url),api-standard-profile-request:(headers),public-profile-url,last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?oauth2_access_token=AQWQ_pGDPgE0WnicHmI6K8TlI4kguauErfuW4t4g9wxcTt0STraOI5l9drba2yQhe9r53qjJvKMhivuFuATQZNVXY0sOmJK22--pTD3j57aonDPokBEqrfKELQtSURoHR0MKbeuRAYEAjqzXp7u2teRuOt4C3NweYuICOva_Wbdk2VKPw-8").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0', 'X-Li-Format'=>'json'}).
        to_return(:status => 200, :body => response_mock, :headers => {})

  end
end