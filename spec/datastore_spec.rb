require 'datastore'

describe Datastore do

  it "holds and returns data as needed" do
    ds = Datastore.new
    ds.add_url("http://www.google.com")
    actual = ds.get_url(1)
    expected = "http://www.google.com"
    expect(actual).to eq expected
  end

  it "count is increased when url is visited" do
    ds = Datastore.new
    ds.add_url("http://www.google.com")
    3.times do
      ds.get_redirect_url(1)
    end
    actual = ds.get_count(1)
    expected = 3
    expect(actual).to eq expected
  end

  it "returns url when a vanity url is sent" do
    ds = Datastore.new
    ds.add_url("http://www.yahoo.com", "cory")
    actual = ds.get_redirect_url("cory")
    expected = "http://www.yahoo.com"
    expect(actual).to eq expected

  end

end