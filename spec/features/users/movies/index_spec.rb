require 'rails_helper'

RSpec.describe 'Movies Index' do
  let!(:users) { create_list(:user, 10) }
  let(:user) { users.first }

  it 'has a button to the discover page' do
    json_response = File.read('spec/fixtures/top_rated_movies.json')
    stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=2f8f6c343a2a2acbd770dfbfbb00e38a&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&vote_count.gte=1000").
      to_return(status: 200, body: json_response)

    visit user_discover_index_path(user)
    click_button 'Find Top Rated Movies'

    click_button('Discover Page')
    expect(current_path).to eq(user_discover_index_path(user))
  end

  it 'shows the top rated movies' do
    json_response = File.read('spec/fixtures/top_rated_movies.json')
    stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=2f8f6c343a2a2acbd770dfbfbb00e38a&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&vote_count.gte=1000").
      to_return(status: 200, body: json_response)

    visit user_discover_index_path(user)
    click_button 'Find Top Rated Movies'

    within('#movie_238') do
      expect(page).to have_content('The Godfather')
      expect(page).to have_content('Vote Average: 8.7')
    end

    within('#movie_315162') do
      expect(page).to have_content('Puss in Boots: The Last Wish')
      expect(page).to have_content('Vote Average: 8.6')
    end

    expect('The Godfather').to appear_before('Puss in Boots: The Last Wish')
  end

  it 'shows movies filtered by title' do
    json_response = File.read('spec/fixtures/movies_with_green.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=2f8f6c343a2a2acbd770dfbfbb00e38a&language=en-US&query=Green&page=1&include_adult=false").
      to_return(status: 200, body: json_response)

    visit user_discover_index_path(user)
    fill_in(:title, with: 'Green')
    click_button 'Find Movies'

    expect(page).to have_content('Green', count: 20)
  end
end