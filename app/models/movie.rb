class Movie < ActiveRecord::Base
  # class method for collection of all possible values of a rating: Movie.all_ratings
  def self.all_ratings
    ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all movies with those ratings
  if !ratings_list.empty?
    return Movie.where(rating: ratings_list)
  # if ratings_list is nil, retrieve ALL movies
  else
    return Movie.all
  end
  end
end