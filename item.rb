class Item < Framework
  attr_accessor :name, :description, :ownerId, :cubeId, :creatorId, :id

  def initialize#{{{
    @name = "a mysterious object"
    @description = "The object adds no weight to your load and is more of a void than matter."
  end#}}}
  def describeItem#{{{
    "\e[1m"+@name+"\e[0m: "+@description
  end#}}}
	def save#{{{
		if @id.nil?
			$myDB.query("insert into items set "+getFields)
			@id = $myDB.insert_id()
		else
			$myDB.query("update items set "+getFields+" where id='"+$myDB.escape_string(@id.to_s)+"'")
		end
	end#}}}
	def setCubeId(id=nil)#{{{
		@cubeId = id
		if id.nil?
			$myDB.query("delete from item_cube where itemId='"+$myDB.escape_string(@id.to_s)+"' and cubeId='"+$myDB.escape_string(@cubeId.to_s)+"' limit 1")
		else
			$myDB.query("insert into item_cube set itemId='"+$myDB.escape_string(@id.to_s)+"',cubeId='"+$myDB.escape_string(@cubeId.to_s)+"'")
		end
	end#}}}
	def setOwnerId(id=nil)#{{{
		if id.nil? || !@ownerId.nil?
			$myDB.query("delete from item_user where itemId='"+$myDB.escape_string(@id.to_s)+"' and userId='"+$myDB.escape_string(@ownerId.to_s)+"' limit 1")
		end
		
		if !id.nil?
			$myDB.query("insert into item_user set itemId='"+$myDB.escape_string(@id.to_s)+"',userId='"+$myDB.escape_string(@ownerId.to_s)+"'")
		end
		@ownerId = id
	end#}}}

	private

	def getFields#{{{
		"name='"+$myDB.escape_string(@name.to_s)+"',description='"+$myDB.escape_string(@description.to_s)+"',creatorId='"+$myDB.escape_string(@creatorId.to_s)+"'"
	end#}}}
	def self.loadForUser(id)#{{{
		items = []
		res = $myDB.query("select i.* from items as i join item_user as iu on i.id=iu.itemId where iu.userId='"+$myDB.escape_string(id.to_s)+"'");
		while !(row = res.fetch_hash).nil?
			item = Item.new
			item.name = row['name']
			item.description = row['description']
			item.creatorId = row['creatorId']
			item.ownerId = id
			items.push item
		end
		items
	end#}}}
	def self.loadForCube(id)#{{{
		items = []
		res = $myDB.query("select i.* from items as i join item_cube as ic on i.id=ic.itemId where ic.cubeId='"+$myDB.escape_string(id.to_s)+"'");
	end#}}}
end
