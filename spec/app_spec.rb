require_relative "../app"
require "capybara/rspec"
require "spec_helper"
require "launchy"
Capybara.app = App
Capybara.app_host = "http://www.example.com"

feature "URL shortener" do

  before :each do

    Migrator.new(SQLDB).run
    App::DB = URLRepository.new(SQLDB)
    App::MESSAGE = nil
    App::MESSAGE_COUNT = 0
  end

  #after do
  #  SQLDB.drop_table :urls
  #end

  scenario "User can enter url to be shortened and sees both original and shortened urls both of which go to the same site." do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    expect(page).to have_content ("https://www.google.com/")
    expect(page).to have_content ("http://www.example.com")
    expect(page).to have_content ("Shorten another URL")
    visit "1"
  end

  scenario "User sees an error message when entering a string that is not a valid url" do
    visit '/'
    fill_in "shorten_url", with: "here's some code "
    click_on "Shorten"
    expect(page).to have_content ("not a valid URL.")
  end

  scenario "User sees an error message when entering an empty string" do
    visit '/'
    fill_in "shorten_url", with: ""
    click_on "Shorten"
    expect(page).to have_content ("The URL cannot be blank.")
  end

  scenario "User enters a blank or invalid URL, followed by a valid URL, Then returns to the homepage via the link and error message no longer exists" do
    visit '/'
    fill_in "shorten_url", with: "haaands"
    click_on "Shorten"
    expect(page).to have_content ("not a valid URL.")
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    visit '/'
    expect(page).to_not have_content("You must enter a valid URL.")
  end

  scenario "User can see number of times URL has been visited via URL shortener" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    click_on "Shorten"
    expect(page).to have_content "0"
    click_on "http://www.example.com"
    visit "/items/1"
    expect(page).to have_content "1"
  end

  scenario "User can create a vanity url" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "rachel"
    click_on "Shorten"
    click_on "http://www.example.com/rachel"
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
    fill_in "vanity_url", with: "fuckeveryone"
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

  scenario "user will not see same error after refreshing the page" do
    visit '/'
    fill_in "shorten_url", with: "fdsaewgwe"
    click_on "Shorten"
    expect(page).to have_content "fdsaewgwe is not a valid URL."
    visit '/'
    expect(page).to_not have_content "is not a valid URL."
  end

  scenario "User will see top form repopulated with url if vanity is already taken" do
    visit '/'
    fill_in "shorten_url", with: "https://www.google.com/"
    fill_in "vanity_url", with: "cory"
    click_on "Shorten"
    visit '/'
    fill_in "shorten_url", with: "https://www.facebook.com/"
    fill_in "vanity_url", with: "cory"
    click_on "Shorten"
    expect(find_field('shorten_url').value).to have_content "https://www.facebook.com/"
  end

end