class Item < Framework
  attr_accessor :name, :description
  def initialize
    @name = "a mysterious object"
    @description = "The object adds no weight to your load and is more of a
    void than matter."
  end

  def describeItem
    "\e[1m"+@name+"\e[0m: "+@description
  end
end
