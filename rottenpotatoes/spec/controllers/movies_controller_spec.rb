require 'rails_helper'

describe MoviesController do
  movie1 = FactoryGirl.create(:movie, :title => "Star Wars", :director => "George Lucas")
  movie2 = FactoryGirl.create(:movie, :title => "Blade Runner", :director => "Ridley Scott")
  movie3 = FactoryGirl.create(:movie, :title => "THX-1138", :director => "George Lucas")
  movie4 = FactoryGirl.create(:movie, :title => "Alien")
  describe 'finding movie with the same director' do
    it 'should call the model method that performs the search' do
      Movie.should_receive(:with_director).with('George Lucas')
      get :search, {:title => 'Star Wars'}
    end
    context 'if it has director' do
      it 'should select the Search Results template for rendering' do
        Movie.stub(:with_director).with('George Lucas')
        get :search, {:title => 'Star Wars'}
        response.should render_template(:search)
      end
      it 'should return the correct matches for movies by the same director' do
        movies = [movie1, movie3]
        Movie.stub(:with_director).with('George Lucas').and_return(movies)
        get :search, {:title => 'Star Wars'}
        expect(assigns(:movies)).to eql(movies)
      end
      it 'should not return the matches of movies by different directors' do
        movies = [movie1, movie3]
        Movie.stub(:with_director).with('George Lucas').and_return(movies)
        get :search, {:title => 'Star Wars'}
        expect(assigns(:movies)).to_not include(movie2, movie4)
      end
    end
    context 'if it does not have director' do
      it 'should redirect to home page' do
        Movie.stub(:with_director).with('Alien').and_return(nil)
        get :search, {:title => 'Alien'}
        expect(assigns(:movies)).to eql(nil)
        expect(response).to redirect_to(movies_path)
      end
    end
  end
  describe 'displaying all movies' do
    it 'should render the index template' do
      get :index
      response.should render_template(:index)
    end
    it 'should display all movies' do
      get :index
      expect(assigns(:movies).length).to eql(Movie.all.count)
    end
  end
  describe 'displaying details of a movie' do
    it 'should render the show template' do
      get :show, {:id => movie1.id}
      response.should render_template(:show)
    end
    it 'should display correct movie' do
      get :show, {:id => movie1.id}
      expect(assigns(:movie)).to eql(movie1)
    end
  end
  describe 'creating new movie' do
    it 'should render the new template' do
      get :new
      response.should render_template(:new)
    end
    it 'should create a new movie' do
      movie5 = FactoryGirl.build(:movie, :director => 'A Fake Director')
      post :create, {:movie => movie5.attributes}
      expect(Movie.with_director('A Fake Director')).to_not eql(nil)
    end
    it 'should redirect to home page' do
      movie5 = FactoryGirl.build(:movie, :director => 'A Fake Director')
      post :create, {:movie => movie5.attributes}
      expect(response).to redirect_to(movies_path)
    end
  end
  describe 'editing a movie' do
    it 'should render the edit template' do
      get :edit, {:id => movie1.id}
      response.should render_template(:edit)
    end
    it 'should display correct movie' do
      get :edit, {:id => movie1.id}
      expect(assigns(:movie)).to eql(movie1)
    end
  end
  describe 'updating a movie' do
    it 'should update the movie' do
      movie = Movie.find_by_title('Alien')
      id = movie.id
      movie.update_attributes(:director => 'Ridley Scott')
      put :update, :id => id, :movie => movie.attributes
      expect(Movie.find_by_id(id).director).to eql('Ridley Scott')
    end
    it 'should redirect to home page' do
      movie = Movie.find_by_title('Alien')
      id = movie.id
      movie.update_attributes(:director => 'Ridley Scott')
      put :update, :id => id, :movie => movie.attributes
      expect(response).to redirect_to(movie_path(movie))
    end
  end
  describe 'destroying a movie' do
    it 'should destroy a movie' do
      id = Movie.find_by_title('THX-1138').id
      delete :destroy, {:id => id}
      expect(Movie.find_by_id(id)).to eql(nil)
    end
    it 'should redirect to home page' do
      delete :destroy, {:id => movie4}
      expect(response).to redirect_to(movies_path)
    end
  end
end