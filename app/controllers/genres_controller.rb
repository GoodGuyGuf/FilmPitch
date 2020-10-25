class GenresController < ApplicationController

  def index
    @genres = Project.genres
  end

  def show
    genre = Project.genres[params[:name].to_sym]

    @projects = Project.find_projects_by_attr(key: :genre, value: genre)
  end
end