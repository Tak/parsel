require "parsel"

RSpec.describe Parsel do
  it "has a version number" do
    expect(Parsel::VERSION).not_to be nil
  end

  it "parses empty parameter list" do
    expect(Parsel::Parsel.parse_arguments([], "")).to eq([])
  end

  it "parses parameter lists" do
    {
      [%i[WORD], "meh"] => ["meh"],
      [%i[WORD WORD], "meh meh"] => %w[meh meh],
      [%i[INTEGER WORD], "365 meh"] => [365, "meh"],
      [%i[INTEGER WORD DATETIME CHANNEL TEXT], "365 meh 2017-04-06 #banana banana plátano"] => [365, "meh", DateTime.parse("April 6, 2017"), "banana", "banana plátano"]
    }.each do |input, output|
      expect(Parsel::Parsel.parse_arguments(*input)).to eq(output)
    end
  end

  it "rejects unknown parameter types" do
    %w[GREUDUMP BANANA NO_U WAT].each do |token_type|
      expect(Parsel::Parsel.parse_arguments([token_type], ["meh"])).to eq(nil)
    end
  end

  it "rejects when argument string token count and parameter lists don't match" do
    [
      [%i[], "lalala"],
      [%i[WORD], nil],
      [%i[WORD], ""],
      [%i[WORD WORD], "meh"],
      [%i[WORD INTEGER], "meh"],
      [%i[INTEGER WORD CHANNEL TEXT], "365 meh #banana "]
    ].each do |parameters|
      expect(Parsel::Parsel.parse_arguments(*parameters)).to eq(nil)
    end
  end

  it "rejects commands with wrong argument types" do
    [
      [%i[CHANNEL WORD], "meh meh"],
      [%i[WORD INTEGER], "meh meh"],
      [%i[DATETIME INTEGER], "meh 2"]
    ].each do |parameters|
      expect(Parsel::Parsel.parse_arguments(*parameters)).to eq(nil)
    end
  end

  context "when parsing datetime" do
    it "rejects multiword dates" do
      [
        [%i[DATETIME], "April 6, 2017"],
        [%i[DATETIME], "6th Apr 2017"]
      ].each do |parameters|
        expect(Parsel::Parsel.parse_arguments(*parameters)).to eq(nil)
      end
    end

    it "accepts rfc 3339 compliant dates" do
      {
        [%i[DATETIME], "2017-04-06"] => [DateTime.parse("April 6, 2017")],
        [%i[DATETIME], "2019-07-28T11:00:00"] => [DateTime.parse("July 28, 2019 11:00:00 AM")]
      }.each do |input, output|
        expect(output).not_to be_nil
        expect(Parsel::Parsel.parse_arguments(*input)).to eq(output)
      end
    end
  end
end
