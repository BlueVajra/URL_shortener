require_relative "../url_shortener"
require "capybara/rspec"
require "spec_helper"
Capybara.app = App

feature "URL shortener" do

  scenario "The user can see the input form and button on homepage" do
    visit '/'
    expect(page).to have_selector("form")
    click_on "Shorten"
  end

  scenario "User can enter url to be shortened and sees both original and shortened urls both of which go to the same site." do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    expect(page).to have_content ("https://www.google.com/")
    expect(page).to have_content ("http://secret-hollows-7655.herokuapp.com/1")
    expect(page).to have_content ("Shorten another URL")
    visit "http://secret-hollows-7655.herokuapp.com/1"
  



  end


end