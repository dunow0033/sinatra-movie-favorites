class MoviesController < ApplicationController
    get '/movies' do

        @drama = []
        @comedy = []
        @action = []
        @horror = []

        Movie.all.each do | movie |
            if movie.shelf == "Drama"
                @drama << movie
            elsif movie.shelf == "Comedy" 
                @comedy << movie
            elsif movie.shelf == "Action" 
                @action << movie
            elsif movie.shelf == "Horror"
                @horror << movie
            end
        end

        if logged_in?
            erb :"movies/index"
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
        if params[:title] == ""
            redirect to '/movies/new'
          else  
            movie = Movie.create(title: params[:title], shelf: params[:shelf])
            current_user.movies << movie
            redirect "/movies"
        end 
    end

    get '/movies/:id/edit' do 
        if logged_in?
            @movie = Movie.find_by_id(params[:id])
            if @movie && @movie.user == current_user
                erb :'movies/edit_movie'
            else  
                redirect to '/movies'
            end 
        else 
            redirect to '/login'
        end 
    end

    patch '/movies/:id' do 
        @movie = Movie.find_by_id(params[:id])

        if params[:title] == ""
            redirect to "/movies/#{@movie.id}/edit"
        else  
            @movie.update(title: params[:title], shelf: params[:shelf])
            
            redirect to "/movies"
        end 
    end 

    delete '/movies/:id' do 
        @movie = Movie.find_by_id(params[:id])

        if @movie && @movie.user == current_user
            @movie.delete 
            redirect to '/movies'
        else 
            redirect to '/login'
        end 
    end 
end