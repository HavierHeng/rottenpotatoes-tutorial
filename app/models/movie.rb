class Movie < ActiveRecord::Base
  def self.all_ratings
    # Movie.select(:rating).distinct.map(&:rating)  # convert to array, however, limited ratings are in db render
    # to be consistent
    %w[G PG PG-13 R NC-17]  # this is shorthand using spaces for array definition instead of  commas and quotes
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

  def self.sort_by(ratings, header)
    # either :release_date or :title for header
    self.with_ratings(ratings).order(header)
  end

end
