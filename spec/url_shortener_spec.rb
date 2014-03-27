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

  scenario "User can enter url to be shortened and sees both original and shortened urls" do
    visit '/'
    fill_in "shorten_url", with: "http://tutorials.gschool.it/"
    click_on "Shorten"
    expect(page).to have_content ("http://tutorials.gschool.it/")
    expect(page).to have_content ("http://secret-hollows-7655.herokuapp.com/1")
    expect(page).to have_content ("Shorten another URL")
  end

end