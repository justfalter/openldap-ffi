module OpenLDAP
  class Entry
    attr_reader :dn

    def initialize(dn, attributes = {})
      @dn = dn
      @data = {}
      attributes.each_pair do |k,v|
        self[k] = v
      end
    end

    def [](n)
      @data[n] || []
    end

    def []=(n,v)
      @data[n] = Kernel::Array(v)
    end

    def count
      @data.count
    end

    def keys
      @data.keys
    end

    def each
      return enum_for(:each) unless block_given?
      @data.each_pair do |k,v|
        yield(k,v)
      end
    end

    def ==(other)
      @dn == other.dn &&
        @data == other.instance_variable_get(:@data)
    end

    def eql?(other)
      self.class == other.class && self == other
    end

    def hash
      [self.class,@dn,@data].hash
    end

    def to_hash
      {
        "dn" => @dn,
        "attributes" => @data
      }
    end

    def from_hash(h)
      new(h["dn"],h["attributes"] || {})
    end

  end
end
