
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
curl -v "https://api.linkedin.com/v1/people/~?oauth2_access_token=AQXgQQmtBtqC24TR9dsgb6jzby4sX7YSsWu3TQ8OEHRwyXTSlrTHEGSxVrNaIJhq-NPl-CH2KC-yxdvS7k_ELRFj_XaoPIaKMhF7-lNeAI_5Tu7nbJFBXTfoxha-WSQXLJSQdcGQzIqXInb18rTTx95XRp9AYaOKOAN3EC2bD2xE48efT1M"

# Profile details
curl -v "https://api.linkedin.com/v1/people/~?oauth2_access_token=AQXgQQmtBtqC24TR9dsgb6jzby4sX7YSsWu3TQ8OEHRwyXTSlrTHEGSxVrNaIJhq-NPl-CH2KC-yxdvS7k_ELRFj_XaoPIaKMhF7-lNeAI_5Tu7nbJFBXTfoxha-WSQXLJSQdcGQzIqXInb18rTTx95XRp9AYaOKOAN3EC2bD2xE48efT1M"
