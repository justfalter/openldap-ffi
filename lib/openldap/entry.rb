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

    def each
      @data.each_pair do |k,v|
        yield(k,v)
      end
    end

    def ==(other)
      @dn == other.dn &&
        @data == other.instance_variable_get(:@data)
    end

    def to_hash
      {
        "dn" => @dn,
        "attributes" => @data
      }
    end

  end
end
