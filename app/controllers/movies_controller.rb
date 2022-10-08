class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      # initialize all_ratings and handle nil cases for the ratings
      @all_ratings = Movie.all_ratings

      # set up array if check boxes are checked
      if params.has_key?(:ratings)
        # grab the keys of the hash using .keys 
        # set to @ratings_to_show (from index.html.erb)
        @ratings_to_show = params[:ratings].keys
      # empty array if no check boxes are checked
      else
        @ratings_to_show = []
      end

      # replace Movie.all (restrict DB query)
      @movies = Movie.with_ratings(@ratings_to_show)

      # create hashed ratings for view
      @hashed_ratings = Hash[@ratings_to_show.map {|key| [key, 1]}]

      # initialize to prevent errors
      @title_header_css, @release_date_header_css = "", ""
      if (params.has_key?(:sort_column))
        if params[:sort_column] == "title"
          # order by the sort_column
          @movies = @movies.order("title")
          # yellow bckgrnd, hilite
          @title_header_css = 'bg-warning hilite'
        elsif params[:sort_column] == "release_date"
          @movies = @movies.order("release_date")
          @release_date_header_css = 'bg-warning hilite'
        end    
      end

    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end