class MoviesController < ApplicationController
    get '/movies' do
        if logged_in?
            erb :"movies/movies"
        else
            redirect '/login'
        end
    end

    get '/movies/new' do
        if logged_in?
            erb :'movies/new_movie'
        else 
            redirect to '/login'
        end 
    end 

    post '/movies' do
        if params[:content] == ""
            redirect to '/movies/new'
          else  
            movie = Movie.create(title: params[:title], director: params[:director], rating: params[:rating], genre: params[:genre])
            current_user.movies << movie
            redirect to "/movies/#{movie.id}"
        end 
    end

    get '/movies/:id' do 
        if logged_in? 
            @movie = Movie.find_by_id(params[:id])
            erb :'movies/show_movie'
        else
            redirect to '/login'
        end 
    end
end