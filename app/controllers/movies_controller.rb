class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.unique_column(:rating)

    session[:sort] = nil unless session.has_key? :sort
    @sort = params.has_key?(:sort) ? params[:sort] : session[:sort]

    session[:ratings] = nil unless session.has_key? :ratings
    @select_ratings = params.has_key?(:ratings) ? params[:ratings] : session[:ratings]

    if not @select_ratings
      @select_ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end

    session[:ratings] = @select_ratings
    session[:sort] = @sort

    if not params.has_key?(:ratings)
      redirect_to :action => :index, :ratings => session[:ratings], :sort => session[:sort]
    end

    @movies = Movie.find(:all, :conditions => ["rating in (?)", @select_ratings.keys], :order => params[:sort])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
