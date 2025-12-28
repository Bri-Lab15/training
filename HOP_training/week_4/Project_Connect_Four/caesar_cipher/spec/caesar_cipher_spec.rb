require_relative "../caesar_cipher"

describe "caesar_cipher" do
  it "shifts letters by 1" do
    expect(caesar_cipher("abc", 1)).to eq("bcd")
  end

  it "keeps uppercase letters uppercase" do
    expect(caesar_cipher("ABC", 1)).to eq("BCD")
  end

  it "wraps around the alphabet" do
    expect(caesar_cipher("z", 1)).to eq("a")
  end

  it "does not change punctuation" do
    expect(caesar_cipher("Hello!", 1)).to eq("Ifmmp!")
  end

  it "works with a shift of 0" do
    expect(caesar_cipher("test", 0)).to eq("test")
  end

  it "works with negative shifts" do
    expect(caesar_cipher("bcd", -1)).to eq("abc")
  end
end
