class Inventory < Framework
  attr_reader :items, :userId
  def initialize#{{{
    @items = []
  end#}}}
  def addItem(item)#{{{
    @items.push item
		if item.ownerId.nil? && !@userId.nil?
			item.setOwnerId @userId
		end
  end#}}}
	def addItems(items)
		items.each do |i|
			addItem i
		end
	end
	def userId=(id)
		@userId = id
		@items.each do |i|
			if i.ownerId.nil?
				i.setOwnerId id
			end
		end
	end
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
