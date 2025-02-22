require 'rails_helper'

RSpec.describe 'Users New' do
  let!(:user) { create(:user) }
  it 'can create a new user' do
    visit new_user_path
    expect(current_path).to eq('/register')

    fill_in('user[name]', with: 'Samuel Cox')
    fill_in('user[email]', with: 'samuel@example.com')
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass123')
    click_button('Register')

    expect(User.exists?(name: 'Samuel Cox')).to eq true
    expect(User.exists?(email: 'samuel@example.com')).to eq true
  end

  it 'will not create a new user if the email already exists' do
    visit new_user_path

    fill_in('user[name]', with: user.name)
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass123')
    click_button('Register')

    expect(page).to have_content('User already exists with given email')
  end

  it 'will not create a user if the email is not filled out' do
    visit new_user_path

    fill_in('user[name]', with: user.name)
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass123')

    click_button('Register')

    expect(page).to have_content("Email can't be blank")
  end

  it 'will not create a user if the name is not filled out' do
    visit new_user_path

    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass123')

    click_button('Register')

    expect(page).to have_content("Name can't be blank")
  end

  it 'will not create a user if the password is not filled out' do
    visit new_user_path

    fill_in('user[email]', with: user.email)
    fill_in('user[name]', with: user.name)

    click_button('Register')

    expect(page).to have_content("Password can't be blank")
  end

  it 'makes sure that the email field is filled in with a real email' do
    visit new_user_path

    fill_in('user[name]', with: user.name)
    fill_in('user[email]', with: 'kyle.email.com')
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass123')

    click_button('Register')

    expect(page).to have_content('Email is invalid')
  end

  it 'will not create if password and confirmation do not match' do
    visit new_user_path

    fill_in('user[name]', with: 'Samuel Cox')
    fill_in('user[email]', with: 'samuel@example.com')
    fill_in('user[password]', with: 'testpass123')
    fill_in('user[password_confirmation]', with: 'testpass125')
    click_button('Register')

    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
