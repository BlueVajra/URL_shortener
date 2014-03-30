require_relative "../url_shortener"
require "capybara/rspec"
require "spec_helper"
require "launchy"
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
    expect(page).to have_content ("http://secret-hollows-7655.herokuapp.com")
    expect(page).to have_content ("Shorten another URL")
    visit "http://secret-hollows-7655.herokuapp.com/1"
  end

  scenario "User sees an error message when entering a string that is not a valid url" do
    visit '/'
    fill_in "shorten_url", with: "I am not a valid url"
    click_on "Shorten"
    expect(page).to have_content ("You must enter a valid URL.")
  end

  scenario "User sees an error message when entering an empty string" do
    visit '/'
    fill_in "shorten_url", with: ""
    click_on "Shorten"
    expect(page).to have_content ("The URL cannot be blank.")
  end

  scenario "User enters a blank or invalid URL, followed by a valid URL, Then returns to the homepage via the link and error message no longer exists"do
    visit '/'
    fill_in "shorten_url", with: "I am not a valid url"
    click_on "Shorten"
    expect(page).to have_content ("You must enter a valid URL.")
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    click_on "Shorten another URL"
    expect(page).to_not have_content("You must enter a valid URL.")
  end

  scenario "User can see number of times URL has been visited via URL shortener" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    expect(page).to have_content "0"
    click_on "http://secret-hollows-7655.herokuapp.com"
    visit "/items/1"
    expect(page).to have_content "1"
  end

  scenario "User can create a vanity url" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "rachel"
    click_on "Shorten"
    expect(page).to have_content "http://secret-hollows-7655.herokuapp.com/rachel"
    click_on "http://secret-hollows-7655.herokuapp.com/rachel"
  end

  scenario "If user attempts to use a taken URL an error message is returned" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "evan"
    click_on "Shorten"
    click_on "Shorten another URL"
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "evan"
    click_on "Shorten"
    expect(page).to have_content "URL already taken"
    expect(page).to have_content "evan"
  end

  scenario "user enters profanity in the vanity url and is returned and error message" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "fuck"
    click_on "Shorten"
    expect(page).to have_content "Vanity url cannot have profanity"
  end

  scenario "user enters a vanity url that is more than 12 chars is returned an error message" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "thisisreallylong"
    click_on "Shorten"
    expect(page).to have_content "Vanity url cannot be more than 12 characters"
  end

  scenario "if user enters vanity that is not all letters they are returned an error message" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "fwh378972"
    click_on "Shorten"
    expect(page).to have_content "Vanity must contain only letters"
  end
end