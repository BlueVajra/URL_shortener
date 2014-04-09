require 'url_repository'
require "spec_helper"

describe URLRepository do
  before do
    Migrator.new(SQLDB).run
    @url_repository = URLRepository.new(SQLDB)
  end

  it "stores urls and gets urls by id" do
    @url_repository.add_url("https://www.google.com/")
    actual = @url_repository.get_url("1")
    expected = "https://www.google.com/"
    expect(actual).to eq expected
  end

  it "stores and gets urls by vanity name" do
    @url_repository.add_url("https://www.yahoo.com/", "cory")
    actual = @url_repository.get_url("cory")
    expected = "https://www.yahoo.com/"
    expect(actual).to eq expected
  end

  it "increases count for every time the url is fetched" do
    @url_repository.add_url("https://www.google.com/")
    @url_repository.add_url("https://www.facebook.com/", "cory")
    @url_repository.add_url("https://www.yahoo.com/")
    @url_repository.get_url("cory")
    @url_repository.get_url("cory")
    @url_repository.get_url("cory")
    actual = @url_repository.get_count("cory")
    expected = 3
    expect(actual).to eq expected
  end

  it "checks to see if vanity url is taken" do
    @url_repository.add_url("https://www.google.com/", "bob")
    @url_repository.add_url("https://www.facebook.com/", "cory")
    actual = @url_repository.vanity_taken?("cory")
    expected = true
    expect(actual).to eq expected
    actual2 = @url_repository.vanity_taken?("john")
    expected2 = false
    expect(actual2).to eq expected2
  end

  it "gets all url stats by id" do
    @url_repository.add_url("https://www.google.com/", "cory")
    @url_repository.get_url("cory")
    @url_repository.get_url("cory")
    @url_repository.get_url("cory")
    actual = @url_repository.get_stats("cory", "http://www.example.com")
    expected = {:short_url => "http://www.example.com/cory", :url => "https://www.google.com/", :count => 3}
    expect(actual).to eq expected
  end

end