class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = session[:all_ratings]
    
    if @all_ratings == nil
      @all_ratings = []
      
      Movie.all.each do |movie|
        @all_ratings.push(movie.rating)
      end
    
      @all_ratings = @all_ratings.uniq
      @selected_ratings = @all_ratings
      
      session[:all_ratings] = @all_ratings
      session[:selected_ratings] = @selected_ratings
    end
    
    if params[:sort] == nil
      params[:sort] = session[:sort]
    else session[:sort] = params[:sort]
    end
    
    if params[:ratings] != nil
      @selected_ratings = []
      
      params[:ratings].each do |key, value|
        @selected_ratings.push(key)
      end
      
      session[:selected_ratings] = @selected_ratings
    else
        @selected_ratings = session[:selected_ratings]
    end
    
    @movies = Movie.where(rating: @selected_ratings).order(params[:sort])  
    
    if params[:sort] == 'title'
      @title_header = 'hilite'
    elsif params[:sort] == 'release_date'
      @release_date_header = 'hilite'
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

end
