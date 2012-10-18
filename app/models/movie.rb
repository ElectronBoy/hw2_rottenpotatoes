class Movie < ActiveRecord::Base
def Movie.unique_column(column)
  return select("distinct(#{column})").map {|movie| movie.rating}
end
end
