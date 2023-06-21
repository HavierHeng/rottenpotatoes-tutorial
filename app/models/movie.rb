class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.select(:rating).distinct.map(&:rating)  # convert to array
  end

  def self.with_ratings(ratings)
    # if ratings_list is nil, retrieve ALL movies
    if ratings.empty?
      return Movie.all
    end
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    Movie.where('LOWER(rating) IN (?)', ratings.map(&:downcase)) 
  end

end
