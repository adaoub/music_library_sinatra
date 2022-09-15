require "spec_helper"
require "rack/test"
require_relative "../../app"

def reset_albums_table
  seed_sql = File.read("spec/seeds/albums_seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read("spec/seeds/artists_seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    reset_albums_table
    reset_artists_table
  end

  context "POST /" do
    it "returns 200 OK" do
      # Assuming the post with id 1 exists.
      response = post("/albums", title: "Voyage", release_year: "2000", artist_id: "3")
      expect(response.status).to eq(200)
      response = get("/albums")
      expected_response = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring, Voyage"
      expect(response.status).to eq(200)
      expect(response.body).to eq (expected_response)
    end
  end

  context "GET /" do
    it "returns 200 OK" do
      # Assuming the post with id 1 exists.
      response = get("/artists")
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "GET /albums/:id" do
    it "returns the album by it's id" do
      response = get("/albums/1")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Doolittle</h1>")
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include("Artist: Pixies")
    end
  end

  context "GET /all_albums" do
    it "returns all albums as HTML" do
      response = get("/all_albums")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
    end
  end

  context "GET /all_albums" do
    it "returns all albums as HTML and links to specific album page" do
      response = get("/all_albums")
      expect(response.status).to eq(200)
      expect(response.body).to include("<a href=\"/albums/1\" > Doolittle </a>")
    end
  end

  context "GET /albums/new" do
    it "returns the album form page" do
      response = get("/albums/new")

      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Add an album</h1>")
      expect(response.body).to include('<form action="/albums" method="POST">')
    end
  end

  context "POST /albums" do
    it "post a new album and return success message" do
      response = post("/albums", title: "Cat", release_year: 2022, artist_id: 2)
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Album Has been ADDED</h1>")
    end
  end

  context "GET /artists/:id" do
    it "return an artist by its id" do
      response = get("/artists/1")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Pixies</h1>")
      expect(response.body).to include("Genre: Rock")
    end
  end

  context "GET /all_artists" do
    it "return all asrtist names with a link to each artist page" do
      response = get("/all_artists")
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1" > Pixies </a>')
    end
  end

  context "Get/artists/new" do
    it "returns a form to add a new artist" do
      response = get("/artists/new")
      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/artists" method="POST">')
    end
  end

  context "POST /artists" do
    it "adds an artist amd return a success messsage" do
      response = post("/artists", name: "david", genre: "rnb")
      expect(response.status).to eq 200

      expect(response.body).to include("<h1> david has been added<h1>")
    end
  end
end
