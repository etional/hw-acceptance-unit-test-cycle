require 'rails_helper'

describe Movie do
  describe '.with_director' do
    movie1 = FactoryGirl.create(:movie, :title => "Star Wars", :director => "George Lucas")
    movie2 = FactoryGirl.create(:movie, :title => "Blade Runner", :director => "Ridley Scott")
    movie3 = FactoryGirl.create(:movie, :title => "THX-1138", :director => "George Lucas")
    movie4 = FactoryGirl.create(:movie, :title => "Alien")
    context 'if it has director' do
      it 'should return the correct matches for movies by the same director' do
        expect(Movie.with_director(movie1.director)).to include(movie1, movie3)
      end
      it 'not return the matches of movies by differnt directors' do
        expect(Movie.with_director(movie1.director)).to_not include(movie2, movie4)
      end
    end
    
    context 'does not have director' do
      it 'should return nothing' do
        expect(Movie.with_director('').empty?).to eql(true)
      end
    end
  end
end