class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings_to_show = params[:ratings].nil? ? [] : params[:ratings].keys 
    if params[:ratings].nil? && params[:sortBy].nil?  # User did not come from special links by pressing Refresh or sort
      # No need to save the session again, as it is still in the cookies
      if session[:ratings].nil? && session[:sortBy].nil?
        # No previous settings found in the session
        @movies = Movie.all
      else
        # Apply previous sorting and filtering settings from the session
        @ratings_to_show = session[:ratings]
        if session[:sortBy].nil?
          @movies = Movie.with_ratings(@ratings_to_show)
        else
          @movies = Movie.sort_by(@ratings_to_show, session[:sortBy])
          set_sorting_headers(session[:sortBy])
        end
      end

    else   # User came from special links, they have params provided, which overrides the sessiosn
      @movies = Movie.with_ratings(@ratings_to_show)

      if params[:sortBy].present?
        @movies = Movie.sort_by(@ratings_to_show, params[:sortBy])
        set_sorting_headers(params[:sortBy])  # update the headers with color
      end

      session[:ratings] = @ratings_to_show
      session[:sortBy] = params[:sortBy]
    end
    
    # set up other class variables that are used in erb
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = Hash[@ratings_to_show.product([1])]

    # default renders app/views/movies/index.html.erb
  end

  private
  def set_sorting_headers(sortBy)
    if params[:sortBy] == 'title'
      @title_header = 'hilite bg-warning'
    elsif
      @release_header = 'hilite bg-warning'
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
