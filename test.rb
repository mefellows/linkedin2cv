
  API_KEY = '75t9gujk0rzk6l' #Your app's API key
  API_SECRET = 'ww922LmfF9JhM8Wx' #Your app's API secret
  REDIRECT_URI = 'http://localhost:3000/accept' #Redirect users after authentication to this path, ensure that you have set up your routes to handle the callbacks
  STATE = SecureRandom.hex(15) #A unique long string that is not easy to guess

  #Instantiate your OAuth2 client object
  def client
    OAuth2::Client.new(
       API_KEY,
       API_SECRET,
       :authorize_url => "/uas/oauth2/authorization?response_type=code", #LinkedIn's authorization path
       :token_url => "/uas/oauth2/accessToken", #LinkedIn's access token path
       :site => "https://www.linkedin.com"
     )
  end

  def index
    authorize
  end

  def authorize
    #Redirect your user in order to authenticate
    redirect_to client.auth_code.authorize_url(:scope => 'r_fullprofile r_emailaddress r_network',
                                               :state => STATE,
                                               :redirect_uri => REDIRECT_URI)
  end

  # This method will handle the callback once the user authorizes your application
  def accept
      #Fetch the 'code' query parameter from the callback
          code = params[:code]
          state = params[:state]

          if !state.eql?(STATE)
             #Reject the request as it may be a result of CSRF
          else
            #Get token object, passing in the authorization code from the previous step
            token = client.auth_code.get_token(code, :redirect_uri => REDIRECT_URI)

            #Use token object to create access token for user
            #(this is required so that you provide the correct param name for the access token)
            access_token = OAuth2::AccessToken.new(client, token.token, {
              :mode => :query,
              :param_name => "oauth2_access_token",
              })

            #Use the access token to make an authenticated API call
            response = access_token.get('https://api.linkedin.com/v1/people/~')

            #Print body of response to command line window
            puts response.body

            # Handle HTTP responses
            case response
              when Net::HTTPUnauthorized
                # Handle 401 Unauthorized response
              when Net::HTTPForbidden
                # Handle 403 Forbidden response
            end
        end
    end
 end


  API_KEY = '75t9gujk0rzk6l' #Your app's API key
  API_SECRET = 'ww922LmfF9JhM8Wx' #Your app's API secret


# Step 1: Get the auth code
https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=75t9gujk0rzk6l&scope=r_fullprofile&state=DCEEFWF45453sdffef424&redirect_uri=https://localhost:8080
# Step2: Get the access token
curl -X POST -H"Content-Type: application/x-www-form-urlencoded" -v "https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&client_id=75t9gujk0rzk6l&client_secret=ww922LmfF9JhM8Wx&redirect_uri=https://localhost:8080&code=AQQ1cLiTvF59ORYKTBOYlJjPAMolXfd4jVzSFu1nog4F3J_el6qfeTGLDQxbRdeO3pre-mHH1mVxF0mxD0BccjCVXMQ0qcWvns4pIIjDXdoW6Q70-DA&state=DCEEFWF45453sdffef424"

token: AQXgQQmtBtqC24TR9dsgb6jzby4sX7YSsWu3TQ8OEHRwyXTSlrTHEGSxVrNaIJhq-NPl-CH2KC-yxdvS7k_ELRFj_XaoPIaKMhF7-lNeAI_5Tu7nbJFBXTfoxha-WSQXLJSQdcGQzIqXInb18rTTx95XRp9AYaOKOAN3EC2bD2xE48efT1M


# Profile
curl -v "https://api.linkedin.com/v1/people/~?oauth2_access_token=AQWQ_pGDPgE0WnicHmI6K8TlI4kguauErfuW4t4g9wxcTt0STraOI5l9drba2yQhe9r53qjJvKMhivuFuATQZNVXY0sOmJK22--pTD3j57aonDPokBEqrfKELQtSURoHR0MKbeuRAYEAjqzXp7u2teRuOt4C3NweYuICOva_Wbdk2VKPw-8"

# Profile details
curl -v "https://api.linkedin.com/v1/people/~?oauth2_access_token=AQXgQQmtBtqC24TR9dsgb6jzby4sX7YSsWu3TQ8OEHRwyXTSlrTHEGSxVrNaIJhq-NPl-CH2KC-yxdvS7k_ELRFj_XaoPIaKMhF7-lNeAI_5Tu7nbJFBXTfoxha-WSQXLJSQdcGQzIqXInb18rTTx95XRp9AYaOKOAN3EC2bD2xE48efT1M"



curl -v "https://api.linkedin.com/v1/people/~:(position,company,publication,patent,language,skills,certification,education,course,volunteer,recommendations)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"
curl -v "https://api.linkedin.com/v1/people/~?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"
curl -v "https://api.linkedin.com/v1/people/~:(people:(id,first-name,last-name,headline,picture-url,industry,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes)),num-results)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"



curl -v "https://api.linkedin.com/v1/people/~:(last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills,certifications,educations,courses,volunteer,three-current-positions,three-past-positions,num-recommenders,recommendations-received,mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"



curl -v "https://api.linkedin.com/v1/people/~:(last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),volunteer:(id,role,organization:(name),cause:(name)),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received,recommendations:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"



curl -v "https://api.linkedin.com/v1/people/~:(last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),volunteer:(id,role,organization:(name),cause:(name)),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"

# Works
curl -v "https://api.linkedin.com/v1/people/~:(last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQWLZ-F5SSlZo0hKMiC4CQTcgoFwVUgJPgHPEMmE7JeKRgj6_3aAEYW9I4WtExHLHyXBEBoZva4ctKmDgNwtVG56FMG0P41toBLIzzqKGTsHKipdpVVB6Bx7cT7vNyL6v7Bz45226bbnJ6JJNsSzorpXI9zxAEQhUUMuR-5GjhiWeIJJcN4"

curl -v "https://api.linkedin.com/v1/people/~:(last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?oauth2_access_token=AQWQ_pGDPgE0WnicHmI6K8TlI4kguauErfuW4t4g9wxcTt0STraOI5l9drba2yQhe9r53qjJvKMhivuFuATQZNVXY0sOmJK22--pTD3j57aonDPokBEqrfKELQtSURoHR0MKbeuRAYEAjqzXp7u2teRuOt4C3NweYuICOva_Wbdk2VKPw-8"
curl -v "https://api.linkedin.com/v1/people/~:(projects,main-address,phone-numbers,email-address,first-name,last-name,maiden-name,formatted-name,phonetic-first-name,phonetic-last-name,formatted-phonetic-name,headline,location:(name,country:(code)),industry,current-status,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,api-standard-profile-request:(url,headers),public-profile-url,last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQUAZ5-05E9BYyrXJOgnLsRSLgIKzvnPZ2Fu3ZbTWlYqxULuRJISbvan1sBCTqUSYGpI5jm1D-4IDOyJxRRTCB4Nkq4jY7oX-nhkYGqJ_IViMqZX3L-DNwYROgTnOBVZpb-QKObXFZZjMdSOnyhmpJ_E7YMAVsYHn8ph7fUhJJACw0AFq4A"


curl -v "https://api.linkedin.com/v1/people/~:(projects:(start-date,description,id,name,url,occupation),main-address,phone-numbers,email-address,first-name,last-name,maiden-name,formatted-name,phonetic-first-name,phonetic-last-name,formatted-phonetic-name,headline,location:(name,country:(code)),industry,current-status,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,api-standard-profile-request:(url,headers),public-profile-url,last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards)?format=json&oauth2_access_token=AQUAZ5-05E9BYyrXJOgnLsRSLgIKzvnPZ2Fu3ZbTWlYqxULuRJISbvan1sBCTqUSYGpI5jm1D-4IDOyJxRRTCB4Nkq4jY7oX-nhkYGqJ_IViMqZX3L-DNwYROgTnOBVZpb-QKObXFZZjMdSOnyhmpJ_E7YMAVsYHn8ph7fUhJJACw0AFq4A"
