require 'openldap/entry'

describe OpenLDAP::Entry do

  let(:dn) { "cn=Jack White,dc=bar,dc=com" }
  let(:attributes) {
    {
      "cn" => ["Jack White"],
      "objectClass" => [ "top", "person" ],
      "sn" => ["White"],
      "givenName" => ["Jack"]

    }

  }
  let(:entry) { described_class.new(dn,attributes) }

  describe "#dn" do
    it "returns the value of the dn" do
      expect(entry.dn).to eq(dn)
    end
  end

  describe "#[]" do
    it "should return an empty array if the attribute does not exist" do
      expect(entry["foobar"]).to match_array([])
    end

    it "should return an array containing the values of the attribute" do
      expect(entry["objectClass"]).to match_array(["top","person"])
      expect(entry["givenName"]).to match_array(["Jack"])
    end
  end

  describe "#[]=" do
    context "when the value is not an array" do
      it "should assign the value to an array" do
        entry["foobar"] = "bla"
        expect(entry["foobar"]).to match_array(["bla"])
      end
    end

    context "when the value is an array" do
      it "should store the array directly" do
        values = ["hey","there"]
        entry["foobar"] = values
        expect(entry["foobar"]).to match_array(values)
        expect(entry["foobar"]).to be(values)
      end
    end
  end

  describe "#count" do
    it "returns the number of attribute keys" do
      expect(entry.count).to eq(4)
    end
  end

  describe "#keys" do
    it "returns an array containing the names of all the attribute keys" do
      expect(entry.keys).to contain_exactly("cn","objectClass","sn","givenName")
    end
  end

  describe "#each" do
    let(:expected) {
      [
        ["cn",["Jack White"]],
        ["sn",["White"]],
        ["objectClass",[ "top", "person" ]],
        ["givenName", ["Jack"]]
      ]
    }
    context "when a block is provided" do
      it "yields once for each attribute key,value pair" do
        found = []
        entry.each do |k,v|
          found << [k,v]
        end
        expect(found).to match_array(expected)
      end
    end

    context "when a block is not provided" do
      it "returns an enumerator that will iterate through each attribute key,value pair"  do
        e = entry.each
        expect(e).to be_a(Enumerator)

        found = []
        e.each do |k,v|
          found << [k,v]
        end
        expect(found).to match_array(expected)
      end
    end
  end

  describe "#==" do
    it "should == itself" do
      expect(entry).to eq(entry)
    end
    it "should == an identically configured entry" do
    end
    it "should not == an entry with a different dn"
    it "should not == an entry with different attribute values"
    it "should not == an entry with different attribute keys"
  end

  describe "#to_hash" do
  end

  describe ".from_hash" do
  end

  context "when placed in a Set" do
  end

end
