require 'rest-client'
require 'json'
require 'pry'

# iterate over the response hash to find the collection of `films` for the given
#   `character`
# collect those film API urls, make a web request to each URL to get the info
#  for that film
# return value of this method should be collection of info about each film.
#  i.e. an array of hashes in which each hash reps a given film
# this collection will be the argument given to `print_movies`
#  and that method will do some nice presentation stuff like puts out a list
#  of movies by title. Have a play around with the puts with other info about a given film.

def get_character_movies_from_api(character_name)
  response_hash = web_request('http://www.swapi.co/api/people/')

  character = find_char(character_name, response_hash)

  character["films"].map do |film|
    web_request(film)
  end
end


def web_request(url)
  JSON.parse(RestClient.get(url))
end


def find_char(character_name, response_hash)
  character = find_in_page(character_name, response_hash)
  until character != nil
    if character
      break
    else
      response_hash = load_next_page(response_hash)
      character = find_in_page(character_name, response_hash)
    end
  end
  character
end


def find_in_page(character_name, response_hash)
  response_hash["results"].find do |character|
    character["name"].downcase == character_name.downcase
  end
end


def load_next_page(current_hash)
  web_request(current_hash["next"])
end


def print_movies(films)
  films.map do |film|
    film["title"]
  end.join(", ")
  # binding.pry
end


def show_character_movies(character)
  films = get_character_movies_from_api(character)
  puts "#{character} was in the following films: #{print_movies(films)}"
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
