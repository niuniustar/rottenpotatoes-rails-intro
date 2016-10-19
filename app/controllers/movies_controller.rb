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
    case params[:sort]
    when 'release_date'
      @movies= Movie.order('release_date')
      @release_hilite = [ 'hilite' ]
      @title_hilite = []
    when 'title'
      @movies= Movie.order('title')
      @title_hilite = [ 'hilite' ]
      @release_hilite = []
    
    else
      @movies= Movie.all
    end
      
      
    @all_ratings=['G','PG','PG-13','R']
    
    if params[:commit] == "Refresh" and params[:ratings].nil?
      @ratings=nil
      session[:ratings] = nil
    elsif params[:ratings]
      @ratings=params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      @ratings=session[:ratings]
      redirect_to movies_path sort:@sort, ratings:@ratings
    else
      @ratings = nil
    end
    

    if params[:sort]
      @sort=params[:sort]
      session[:sort]=params[:sort]
    elsif session[:sort]
      @sort=session[:sort]
    else
      @sort=nil
    end
    
    
    
    if !@ratings
      @ratings = Hash.new
    end
    
    if @sort and @ratings
      @movies = Movie.where(rating: @ratings.keys).order(@sort)
    elsif @sort
      @movies = Movie.order(@sort)
    elsif @ratings
      @movies = Movie.where(rating: @ratings.keys)
    else
      @movies = Movie.all
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
