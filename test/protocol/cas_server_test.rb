require File.dirname(__FILE__) + "/../test_helper"
require "rack/test"
require File.dirname(__FILE__) + "/../../classy_cas"

class CasServerTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    Sinatra::Application.new
  end

  context "A CAS server" do
    # 2.1
    context "/login as credential requestor" do
      # 2.1.1
      context "parameters" do
        should "request credentials" do
          get "/login"
          
          assert_have_selector "form"
        end

        context "a single sign-on session already exists" do
          should "notify the client that it is already logged in"
        end

        context "with a 'service' parameter" do
          should "be url-encoded" do
            service_url = "http://example.com?page=foo bar"

            get "/login?service=#{URI.encode(service_url)}"
            assert last_response.ok?

            assert_raise(URI::InvalidURIError) { get "/login?service=#{service_url}" }
          end
                
          context "a single sign-on session already exists" do

          end
        end
      
        context "with a 'renew' parameter" do
          context "a single sign-on session already exists" do
            should "bypass single sign on and force the client to renew"
          end

          context "with a 'gateway' parameter" do
            # RECOMMENDED
            should "have 'renew' take precedence over a 'gateway' parameter"
          end
        end
      
        context "with a 'gateway' parameter" do
          # RECOMMENDED
          should "request credentials as though neither 'gateway' or 'service' were set"
        
          context "with a 'service' parameter" do
            should "not ask for credentials"

            context "a single sign-on session already exists" do
              # MAY
              should "redirect the client to the service URL, appending a valid service ticket"
            
              # MAY
              # should "interpose an advisory page informing the client that a CAS authentication has taken place"
            end
            # MUST
            should "redirect the client to the service URL without a ticket"
          end
        end
      end
    
      # 2.1.3
      context "response for username/password authentication" do
        # MUST
        should "include a form with the parameters, 'username', 'password', and 'lt'" do
          get "/login"
          
          assert_have_selector "input[name='username']"
          assert_have_selector "input[name='password']"
          assert_have_selector "input[name='lt']"
        end
      
        # MAY
        should "include the parameter 'warn' in the form" do
          get "/login"

          assert_have_selector "input[name='warn']"
        end
      
        context "with a 'service' parameter" do
          setup { @service_url = "http://example.com?page=foo bar" }
          # MUST
          should "include the parameter 'service' in the form" do
            get "/login?service=#{URI.encode(@service_url)}"
            
            assert_have_selector "input[name='service']"
            assert field_named("service").value == @service_url
          end
        end
      end
    
      # 2.1.4
      context "response for trust authentication" do
        # TODO
      end
    
      # 2.1.5
      context "response for single sign-on authentication" do
        context "a single sign-on session already exists" do
          # As 2.2.4
        end
        # As 2.1.3 or 2.1.4
      end
    end

    # 2.2
    context "/login as credential acceptor" do
      # 2.2.1
      # Tests in 2.2.4
      # context "parameters common to all types of authentication" do
      #   context "with a 'service' parameter" do
      #     # MUST
      #     should "redirect the client to the 'service' url"
      #   end
      #   
      #   context "with a 'warn' parameter" do
      #     # MUST
      #     should "prompt the client before authenticating on another service"
      #   end
      # end
      
      # 2.2.2
      context "parameters for username/password authentication" do
        # MUST
        should "require 'username', 'password', and 'lt' (login ticket) parameters" do
          post "/login"
          
          assert !last_response.ok?
        end
      end
      
      # 2.2.3
      context "parameters for trust verification" do
        # TODO
      end
      
      # 2.2.4
      context "responding" do
        context "with success" do
          context "with a 'service' parameter" do
            # MUST
            should "cause the client the send a GET request to the 'service'"
            
            # MUST
            should "not forward the client's credentials to the 'service'"
          end
          
          # MUST
          should "display a message notifying the client that it has successfully initiated a single sign-on session"
        end
        
        context "with failure" do
          should "return to /login as a credential requester"
          
          # RECOMMENDED
          should "display an error message describing why login failed"
          
          # RECOMMENDED
          should "provide an opportunity to attempt to login again"
        end
      end
    end
    
    # 2.3
    context "/logout" do
      context "parameters" do
      end

      # 2.3.3
      context "response" do
        # MUST
        should "display a page stating that user has been logged out"

        # 2.3.1
        context "with a 'url' parameter" do
          # MAY
          should "link back to 'url' on the logout page"
        end
      end
    end

    # 2.4 [CAS 1.0: Skipped]
    
    # 2.5
    context "/serviceValidate" do
      
    end
  end
end