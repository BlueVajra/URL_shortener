require 'bad_words'

describe Badwords do

  it "returns true if profanity is in the string" do
    bad = Badwords.new
    actual = bad.has_profanity? ("hitherefuckyou")
    expected = true
    expect(actual).to eq expected
  end

  it "returns false if no profanity is in the string" do
    bad = Badwords.new
    actual = bad.has_profanity? ("iamsonice")
    expected = false
    expect(actual).to eq expected
  end

end