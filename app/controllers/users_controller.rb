class UsersController < ApplicationController
    get '/signup' do
        if !session[:user_id]
            erb :'users/create_user'
        else
            redirect "/movies"
        end
    end

    post '/signup' do
        @user = User.new(username: params[:username], email: params[:email], password: params[:password])

        if params[:username] == "" || params[:email] == '' || params[:password] == ''
            @error = "All fields are required!!  Please try again!!"
            erb :'users/create_user'
        elsif User.find_by(username: params[:username])
            @error = "That name is already taken!!  Please choose another!!"
            erb :'users/create_user'
        else
            @user.save
            session[:user_id] = @user.id
            redirect '/movies'
        end
    end

    get '/login' do
        if logged_in?
            redirect "/movies"
        else
            erb :'users/login'
        end
    end

    post '/login' do 
        if params["username"].empty? || params["password"].empty?
            @error = "username and password can't be blank!!  Please try again!!"
            erb :'users/login'
        else
            @user = User.find_by(username: params[:username])

            if @user && @user.authenticate(params[:password])
                session[:user_id] = @user.id
                redirect '/movies'
            else
                @error = "Sorry, invalid user credentials.  Please try again, or sign up for a new account!!"
                erb :'users/login'
            end
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            redirect '/login'
        else
            redirect '/'
        end
    end
end