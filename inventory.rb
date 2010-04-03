class Inventory < Framework
  attr_reader :items
  def initialize#{{{
    @items = []
  end#}}}
  def addItem(item)#{{{
    @items.push item
  end#}}}
  def delItem(item)#{{{
    if @items.include?(item)
      @items.delete item
      return true
    else
      return false
    end
  end#}}}
  def getItem(num)#{{{
    return @items[num] unless @items[num].nil?
    return nil
  end#}}}
  def describeInventory#{{{
    str = "You have the following in your inventory:\n"
    j = 0
    @items.each do |i|
      j += 1
      str += j.to_s+") "+i.describeItem+"\n"
    end
    str
  end#}}}
end
