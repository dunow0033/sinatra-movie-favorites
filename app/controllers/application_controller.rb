#need to include the securerandom gem for generating a random session secret
require 'securerandom'

#main controller class inheriting from Sinatra Base
class ApplicationController < Sinatra::Base

    #main configurations for setting the public folder, the views folder, enabling sessions, and setting the session secret with the secure random gem
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    end

    #route for the initial homepage
    get '/' do
        erb :index
    end
   
    #helper methods help determine who the current user is and if they are logged in
    helpers do
        def logged_in?
          !!current_user
        end
    
        def current_user
          User.find(session[:user_id]) if session[:user_id]
        end
    end
end