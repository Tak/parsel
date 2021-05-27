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
      [%i[INTEGER WORD CHANNEL TEXT], "365 meh #banana banana plátano"] => [365, "meh", "banana", "banana plátano"]
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
      [%i[WORD INTEGER], "meh meh"]
    ].each do |parameters|
      expect(Parsel::Parsel.parse_arguments(*parameters)).to eq(nil)
    end
  end
end
