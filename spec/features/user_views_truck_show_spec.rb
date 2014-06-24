require 'rails_helper'

feature 'user views food truck show page', %Q{
  As a user
  I want to be able to select a food truck from the index page
  So that I can see its information and reviews (/foodtrucks/:foodtruck_id)
} do

  scenario 'user can see a food truck basic info' do
    attrs = {
      name: 'stokes',
      description: 'This is at least a fifty-character description of a food truck.',
      category: 'Pizza'
    }

    truck = FoodTruck.create!(attrs)

    visit food_truck_path(truck)

    expect(page).to have_content truck.name
    expect(page).to have_content truck.description
    expect(page).to have_content truck.category
  end

  scenario 'user can see food truck reviews' do

    attrs = {
      name: 'stokes',
      description: 'This is at least a fifty-character description of a food truck.',
      category: 'Pizza'
    }

    truck = FoodTruck.create!(attrs)

    user_attrs = {
      email: 'foo@bar.net',
      password: 'foobar92'
    }

    test_user = User.create!(user_attrs)

    review_attrs = {
      rating: 3,
      user: test_user,
      body: 'This is at least a fifty-character review of a food truck.',
      food_truck: truck
    }

    review = Review.create!(review_attrs)

    visit food_truck_path(truck)

    expect(page).to have_content review.rating
    expect(page).to have_content review.body
  end
end