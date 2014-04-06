require_relative '../lib/url_validator'


describe "Url validator" do

  it "returns error message if the url is blank" do
    validator = URLvalidator.new("")
    actual = validator.error_message
    expected = "The URL cannot be blank."
    expect(actual).to eq expected

    expect(validator.is_valid?).to eq false
  end

  it "returns error message if the url is not a proper url" do
    validator = URLvalidator.new("https://wwwgooglecom")
    actual = validator.error_message
    expected = "https://wwwgooglecom is not a valid URL."
    expect(actual).to eq expected

    expect(validator.is_valid?).to eq false
  end

  it "returns error message if the vanity url is over 12 characters" do
    validator = URLvalidator.new("https://www.google.com", "ahfjealhfewuhjfewahg")
    actual = validator.error_message
    expected = "Vanity url cannot be more than 12 characters"
    expect(actual).to eq expected

    expect(validator.is_valid?).to eq false
  end

  it "returns error message if the vanity url is not only letters" do
    validator = URLvalidator.new("https://www.google.com", "iamhappy123")
    actual = validator.error_message
    expected = "Vanity must contain only letters"
    expect(actual).to eq expected

    expect(validator.is_valid?).to eq false
  end

  it "returns error message if the vanity url contains profanity" do
    validator = URLvalidator.new("https://www.google.com", "heyfuckyou")
    actual = validator.error_message
    expected = "Vanity url cannot have profanity"
    expect(actual).to eq expected
  end

  it "returns true if regular url is valid" do
    validator = URLvalidator.new("https://www.google.com")
    actual = validator.is_valid?
    expected = true
    expect(actual).to eq expected
  end

  it "returns true if regular url and vanity url is valid" do
    validator = URLvalidator.new("https://www.google.com", "cory")
    actual = validator.is_valid?
    expected = true
    expect(actual).to eq expected
  end

end