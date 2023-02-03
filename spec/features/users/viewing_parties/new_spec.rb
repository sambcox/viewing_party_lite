require 'rails_helper'

RSpec.describe 'Viewing Party New' do
  let!(:users) { create_list(:user, 10) }
  let(:user) { users.first }

  it 'can create a new viewing party' do
    visit new_user_movie_viewing_party_path(user, 238)
    start_time = Time.now

    expect(page).to have_field('viewing_party[duration]', with: 175 )

    fill_in('viewing_party[date]', with: Date.today)
    fill_in('viewing_party[start_time]', with: start_time)

    page.check("viewing_party[#{users.second.id}]")
    page.check("viewing_party[#{users.fourth.id}]")

    click_button('Create Viewing Party')

    expect(current_path).to eq(user_path(user))
    viewing_party = ViewingParty.first

    expect(viewing_party.date).to eq(Date.today)
    expect(viewing_party.start_time.strftime('%H:%M')).to eq(start_time.utc.strftime('%H:%M'))
    expect(viewing_party.users).to eq([users.first, users.second, users.fourth])
    user_viewing_party_1 = UserViewingParty.find_by(user_id: user.id)
    user_viewing_party_2 = UserViewingParty.find_by(user_id: users.second.id)
    expect(user_viewing_party_1.hosting).to eq(true)
    expect(user_viewing_party_2.hosting).to eq(false)
  end

  xit 'will not create if runtime is longer than duration' do
    visit new_user_movie_viewing_party_path(user, 238)
    start_time = Time.now

    fill_in('viewing_party[duration]', with: 100 )
    fill_in('viewing_party[date]', with: Date.today)
    fill_in('viewing_party[start_time]', with: start_time)

    page.check("viewing_party[#{users.second.id}]")
    page.check("viewing_party[#{users.fourth.id}]")

    click_button('Create Viewing Party')

    expect(current_path).to eq(new_user_movie_viewing_party_path(user, 238))
  end
end