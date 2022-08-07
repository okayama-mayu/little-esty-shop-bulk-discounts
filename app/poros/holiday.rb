class Holiday 
  attr_reader :name, :date, :global 

  def initialize(data)
    @name = data[:localName]
    @date = data[:date]
    @global = data[:global]
  end
end