# {{ POST/albums }} {{ PATH}} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <div>200 OK</div>
    
  </body>
</html>
```

```html
<!-- EXAMPLE -->
<!-- Response when the post is not found: 404 Not Found -->

<html>
  <head></head>
  <body>
    <h1>Sorry!</h1>
    <div>We couldn't find this post. Have a look at the homepage?</div>
  </body>
</html>
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /albums

with body parameters: tilte = ?, release_year = ?, artist_id = ?

Response: None (just creates the resource on the server)

```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/albums', title: "Voyage", release_year: "2000", artist_id: "3")

      expect(response.status).to eq(200)
       
    end

  
    end

    context "GET /" do
    it "returns an albums" do
      response = get('/albums/:id/2')
      expect(response.status).to eq(200)
      expect(response.body.title).to eq ("Surfer Rosa")
    end
    end



end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.

