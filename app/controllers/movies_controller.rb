class MoviesController < ApplicationController

    #the get action for the /movies route
    get '/movies' do
        #check to see if the user is logged in first, then make empty arrays for every
        #shelf category
        if logged_in?
            @drama = []
            @comedy = []
            @action = []
            @horror = []

            #go through the array of movies for the currently logged in user, and for each movie, compare it's shelf
            #value to string value of each display category.  If it's equal to any of those, then put the movie into the
            #appropriate array created above
            current_user.movies.each do | movie |
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

            #after the arrays are appropriately created and filled, send the information to the index page
            erb :"movies/index"
        else
            #if the user is not logged in, redirect to the login page
            redirect '/login'
        end
    end

    #get route for the new movies route
    get '/movies/new' do
        #if the user is logged in, send them to the new movie form page
        if logged_in?
            erb :'movies/new_movie'
        else 
            #otherwise, redirect them to the login page
            redirect to '/login'
        end 
    end 

    #post route for the /movies route
    post '/movies' do
        #if title passed in was blank, redirect to the new movie form
        if params[:title] == ""
            redirect to '/movies/new'
        else
            #otherwise create a new movie, with title and shelf parameters, put it onto the movies array
            #of the current user, then redirect to the movies index page
            movie = Movie.create(title: params[:title], shelf: params[:shelf])
            current_user.movies << movie
            redirect "/movies"
        end 
    end

    #get route for the individual edit page for an individual movie
    get '/movies/:id/edit' do 
        #if the user is logged in, find the movie by it's id.  If that movie is found, and the movie's user attribute
        #matches the current user, go to the edit movie page for that movie
        if logged_in?
            @movie = Movie.find_by_id(params[:id])
            if @movie && @movie.user == current_user
                erb :'movies/edit_movie'
            else 
                #otherwise, redirect back to the movies index page
                redirect to '/movies'
            end 
        else 
            #if the user is not logged in, redirect back to the login page
            redirect to '/login'
        end 
    end

    #patch route to handle an individual movie's edit route submission
    patch '/movies/:id' do 
        #find the movie by it's id
        @movie = Movie.find_by_id(params[:id])

        #if the title is blank, redirect to the individual movie's edit form
        if params[:title] == ""
            redirect to "/movies/#{@movie.id}/edit"
            #check if user logged in is the same user that owns the movie
        elsif session[:user_id] != @movie.user_id
            redirect '/login'
        else
            #otherwise, update the movie with the new movie title and shelf name that was passed in
            @movie.update(title: params[:title], shelf: params[:shelf])
            
            #then redirect back to the movies index page
            redirect to "/movies"
        end 
    end 

    #delete route for the individual movie
    delete '/movies/:id' do 
        #find the movie by it's id
        @movie = Movie.find_by_id(params[:id])

        #If that movie is found, and the movie's user attribute
        #matches the current user, delete the movie, then redirect back to the main movies index page
        if @movie && @movie.user == current_user
            @movie.delete 
            redirect to '/movies'
        else 
            #otherwise, redirect back to login to match the logged in user with the current user
            #trying to delete a movie
            redirect to '/login'
        end 
    end 
end