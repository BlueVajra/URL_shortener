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

end