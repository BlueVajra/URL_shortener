require 'url_repository'

describe URLRepository do
  before do
    #@db = URLRepository.new("http://www.example.com")
    @db = URLRepository.new
  end

  it "stores urls and gets urls by id" do
    @db.add_url("https://www.google.com/")
    actual = @db.get_url("1")
    expected = "https://www.google.com/"
    expect(actual).to eq expected
  end

  it "stores and gets urls by vanity name" do
    @db.add_url("https://www.yahoo.com/", "cory")
    actual = @db.get_url("cory")
    expected = "https://www.yahoo.com/"
    expect(actual).to eq expected
  end

  it "increases count for every time the url is fetched" do
    @db.add_url("https://www.google.com/")
    @db.add_url("https://www.facebook.com/", "cory")
    @db.add_url("https://www.yahoo.com/")
    @db.get_url("cory")
    @db.get_url("cory")
    @db.get_url("cory")
    actual = @db.get_count("cory")
    expected = 3
    expect(actual).to eq expected
  end

  it "checks to see if vanity url is taken" do
    @db.add_url("https://www.google.com/", "bob")
    @db.add_url("https://www.facebook.com/", "cory")
    actual = @db.vanity_taken?("cory")
    expected = true
    expect(actual).to eq expected
    actual2 = @db.vanity_taken?("john")
    expected2 = false
    expect(actual2).to eq expected2
  end

  it "gets all url stats by id" do
    @db.add_url("https://www.google.com/", "cory")
    @db.get_url("cory")
    @db.get_url("cory")
    @db.get_url("cory")
    actual = @db.get_stats("cory", "http://www.example.com")
    expected = {:redirect => "http://www.example.com/cory", :url => "https://www.google.com/", :count => 3}
    expect(actual).to eq expected
  end

end