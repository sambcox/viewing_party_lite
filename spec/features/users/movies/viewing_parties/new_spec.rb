require 'rails_helper'

RSpec.describe 'Viewing Party New' do
  let!(:users) { create_list(:user, 10) }
  let(:user) { users.first }

  it 'can create a new viewing party' do
    json_response = File.read('spec/fixtures/the_godfather.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['movie_api_key']}&language=en-US").
      to_return(status: 200, body: json_response)
    visit new_user_movie_viewing_party_path(user, 238)
    start_time = Time.now
    
    expect(page).to have_field('viewing_party[duration]', with: 175 )

    fill_in('viewing_party[date]', with: Date.today)
    fill_in('viewing_party[start_time]', with: start_time)

    page.check("viewing_party[user_#{users.second.id}]")
    page.check("viewing_party[user_#{users.fourth.id}]")

    click_button('Create Viewing Party')

    expect(current_path).to eq(user_path(user))
    viewing_party = ViewingParty.first

    expect(viewing_party.date).to eq(Date.today)
    expect(viewing_party.time).to eq(start_time)
    expect(viewing_party.users).to eq([users.first, users.second, users.fourth])
    user_viewing_party_1 = UserViewingParty.find_by(user_id: user.id)
    user_viewing_party_2 = UserViewingParty.find_by(user_id: users.second.id)
    expect(user_viewing_party_1.hosting).to eq(true)
    expect(user_viewing_party_2.hosting).to eq(false)
  end
end