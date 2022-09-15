# file: app.rb
require "sinatra"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/album_repository"
require_relative "lib/artist_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "lib/album_repository"
    also_reload "lib/artist_repository"
  end

  post "/albums" do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id].to_i

    repo.create(album)

    return erb(:album_create)
  end

  get "/albums" do
    repo = AlbumRepository.new
    albums = repo.all

    responce = albums.map { |album| album.title }.join(", ")

    return responce
  end

  get "/artists" do
    repo = ArtistRepository.new
    artists = repo.all
    results = artists.map { |artist| artist.name }.join(", ")

    return results
  end

  get "/albums/new" do
    return erb(:album_form)
  end

  get "/albums/:id" do
    repo = AlbumRepository.new
    artist = ArtistRepository.new
    @album = repo.find(params[:id])
    @artist = artist.find(@album.artist_id)

    return erb(:album)
  end

  get "/all_albums" do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get "/all_artists" do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:artists)
  end

  get "/artists/new" do
    return erb(:new_artist)
  end

  post "/artists" do
    repo = ArtistRepository.new
    @artist = Artist.new
    @artist.name = params[:name]
    @artist.genre = params[:genre]

    repo.create(@artist)
    return erb(:artist_added)
  end

  get "/artists/:id" do
    artist = ArtistRepository.new

    @artist = artist.find(params[:id])

    return erb(:artist)
  end
end
