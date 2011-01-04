class Handler < Framework
  attr_accessor :sock, :tokens, :allSocks
  @@synonyms = {}

  def initialize(sock,tokens,allSocks)#{{{
    @sock = sock
    @tokens = tokens
    @allSocks = allSocks
    @allNames = []
		@permitted = [:register,:identify,:help]
  end#}}}

  def go#{{{
    if @tokens[1].nil?
      @sock.terminal.send "You have control of your fate in the world. Where do you want to go?" if @sock.sockType == SockTypeUser
			return
		end

		dir = @tokens[1].downcase
    if !%w{north south east west up down}.include?(dir)
      @sock.terminal.send "That may be the road less traveled by, but choosing a recognizable direction will make all the difference." if @sock.sockType == SockTypeUser
    else
			if !@sock.user.cube.goToDirn?(dir)
				@sock.terminal.send "You can't go that way." if @sock.sockType == SockTypeUser
			else
				cube = @sock.user.cube.changeCube(dir)
				if cube.exists?
					case dir
						when 'north','south','east','west'
							leaveBroadcastMsg = " has ventured off toward the "+dir+"."
							arriveBroadcastMsg = " has joined us from the "+Direction.oppositeDirn(dir)+"."
						when 'up','down'
							leaveBroadcastMsg = " has ventured "+dir+"."
							arriveBroadcastMsg = " has joined us from "+(dir == "up" ? "below" : "above")
					end
					broadcast @sock.user.name+leaveBroadcastMsg, @sock, false
					@sock.user.cube = cube
					broadcast @sock.user.name+arriveBroadcastMsg, @sock, false
					@sock.terminal.send Terminal.getLine
					@sock.terminal.send @sock.describeCube
				else
					@sock.terminal.send "You can't go that way." if @sock.sockType == SockTypeUser
				end
			end
    end
  end#}}}
  def look#{{{
    broadcast @sock.user.name+" looks around.", @sock, false
    @sock.terminal.pushString Terminal.getLine if @sock.sockType == SockTypeUser
    @sock.terminal.send @sock.describeCube
  end#}}}
  def help#{{{
    cmds = [
      'go <direction>',
      'help',
			'register <name> <password>',
      'identify <name> <password>',
      'inventory',
      'look','me <third-person action>',
      'make <parameters>',
      'me <action>',
      'move <earth|wind|fire> <direction> <parameters>',
      'name <name>',
      'sit',
      'stand',
      'quit',
      'yell <message>'
    ]
    str = Terminal.getLine
    str += "Allowed commands:\n"+cmds.collect{|c| $cmdChar+c }.join("\n")
    str += "\nIf you're having trouble with backspace in your terminal, you can end any line with \"<C>\" (without quotes) and press <enter> to cancel that command."
    str += Terminal.getLine
    @sock.terminal.send str
  end#}}}
  def name#{{{
    if @tokens[1].nil?
      @sock.terminal.send "You are currently dubbed \""+@sock.user.name+"\"." if @sock.sockType == SockTypeUser
    elsif nameUsed?(@tokens[1])
      @sock.terminal.send "You may not assume the identity of another."
    else
			while @sock.sockType == SockTypeAnim && !@tokens[1].index('_').nil?
				@tokens[1].sub!('_',' ')
			end
      broadcast @sock.user.name+" is now dubbed "+@tokens[1], @sock
      @sock.user.name = @tokens[1]
    end
  end#}}}
	def register#{{{
		if @tokens[2].nil?
			@sock.terminal.send "You must request a name and share a secret."
		else
			@sock.user.register @tokens[1], @tokens[2]
		end
	end#}}}
  def identify#{{{
    if @tokens[2].nil?
      @sock.terminal.send "The world cannot recognize you without more information!"
    else
      if @sock.user.identify(@tokens[1],@tokens[2])
        broadcast @sock.user.name+" raises closed eyes to the sky, enlightened in the ways of playing the instruments.", @sock, false
      end
    end
  end#}}}
  def move#{{{
    if @tokens[2].nil?
      @sock.terminal.send "You must pronounce what to move, where to move, how to move."
    else
      @tokens.shift
      moveWhat = @tokens.shift
      moveDirn = @tokens.shift
      if moveWhat == 'earth'
        if @sock.user.em.to_i != 1
          @sock.terminal.send "Aren't you a little small for an Earth Mover?"
        else
          moveEarth(@sock,moveDirn,@tokens.join(' '))
        end
      elsif moveWhat == 'wind'
        if @sock.user.wm.to_i != 1
          @sock.terminal.send "Aren't you a little small for a Wind Mover?"
        else
          moveWind(@sock,moveDirn,@tokens.join(' '))
        end
      elsif moveWhat == 'fire'
        if @sock.user.fm.to_i != 1
          @sock.terminal.send "Aren't you a little small for a Fire Mover?"
        else
          moveFire(@sock,moveDirn)
        end
      end
    end
  end#}}}
	def debug#{{{
		if @sock.user.admin.to_i != 1
			notCommand
		else
			@sock.terminal.send "Coords: "+@sock.user.cube.x.to_s+","+@sock.user.cube.y.to_s+","+@sock.user.cube.z.to_s
		end
	end#}}}
  def me#{{{
    @tokens.shift
    broadcast @sock.user.name+" "+@tokens.join(' '), @sock
  end#}}}
  def yell#{{{
    @tokens.shift
    str = @sock.user.name+" yells<dirn>, \""+@tokens.join(' ')+"\e[0m\""
    broadcast str.sub('<dirn>',''), @sock
    %w{ north south east west up down }.each do |d|
      dirn = Direction.new(@sock.user.cube.x, @sock.user.cube.y, @sock.user.cube.z, d)
      coords = dirn.toCoords
      d = dirn.fromDirn
      dirnstr = " from "
      if d == "up"
        dirnstr += "above"
      elsif d == "down"
        dirnstr += "below" 
      else
        dirnstr += "the "+d
      end
      @allSocks.each do |s|
        if s.user.cube.x == coords[0] && s.user.cube.y == coords[1] && s.user.cube.z == coords[2]
          broadcast str.sub('<dirn>',dirnstr), s
          break
        end
      end
    end
  end#}}}
  def sit#{{{
    if sock.user.sitting
      sock.terminal.send "You're already sitting." if @sock.sockType == SockTypeUser
    else
      sock.user.sitting = true
      tokens.shift
      sock.user.sitmsg = tokens.join(' ')
      broadcast sock.user.name+" sits"+(sock.user.sitmsg != '' ? " "+sock.user.sitmsg : '')+".", sock, false
			sock.terminal.send "You sit."
    end
  end#}}}
  def stand#{{{
    if !@sock.user.sitting
      @sock.terminal.send "You can't stand any taller." if @sock.sockType == SockTypeUser
    else
      @sock.user.sitting = false
      @sock.user.sitmsg = ''
      broadcast @sock.user.name+" stands.", @sock
    end
  end#}}}
  def inventory#{{{
    sock.terminal.send sock.user.inventory.describeInventory
  end#}}}
  def quit#{{{
    broadcast @sock.user.name+" disappears into a thin mist.", @sock
    @sock.close
    @allSocks.delete @sock
  end#}}}
  def make#{{{
    @tokens.shift
		if @tokens[0].nil?
			@sock.terminal.send "You have to make *something*."
			return
		end
    params = {}
    temp = @tokens.join(' ').split(';')
    temp.each do |t|
      t = t.split(':')
      params[t[0]] = t[1]
    end
    item = Item.new
		item.name = params['name'] unless params['name'].nil?
    item.description = params['description'] unless params['name'].nil?
		if !@sock.user.id.nil?
			item.creatorId = @sock.user.id
			item.save
			item.setOwnerId @sock.user.id
		end
    @sock.user.inventory.addItem item
		broadcast @sock.user.name+" clasps his hands together and, with much concentration, slowly opens them to reveal "+item.name+".", @sock
  end#}}}
  def give#{{{
    if @tokens[2].nil?
      @sock.terminal.send "You must say what to give and who to give it to!"
      return
    end
    giveTo = getSockWithName(@tokens[1])
    giveWhat = getItem(@tokens[2])
    if giveWhat.nil?
      @sock.terminal.send "You don't even have that many items!"
    elsif giveTo.nil?
      @sock.terminal.send "Your companion by that name must have been claimed by the mist."
    elsif !@sock.user.sameCubeAs(giveTo.user.cube)
      @sock.terminal.send "Your companion by that name is nowhere in sight."
    else
      broadcast @sock.user.name+" gives "+giveWhat.name+" to "+giveTo.user.name, @sock
			giveWhat.setOwnerId giveTo.user.id
      giveTo.user.inventory.addItem giveWhat
      @sock.user.inventory.delItem giveWhat
    end
  end#}}}
  def animal#{{{
    @sock.sockType = SockTypeAnim if @tokens[1] == "4n1m4l"
  end#}}}
  def transport#{{{
    if @sock.sockType == SockTypeAnim || @sock.user.fm.to_i == 1
      cube = Cube.new(@tokens[1].to_i,@tokens[2].to_i,@tokens[3].to_i)
      @sock.user.cube = cube if cube.exists?
      @sock.terminal.send @sock.describeCube
    end
  end#}}}
	def animact#{{{
		if @sock.user.fm.to_i == 1
			$animalActivityRate = @tokens[1].to_f
		end
	end#}}}
  def method_missing(method)#{{{
    synonym = findSynonym method
    return eval(synonym.to_s) unless synonym.nil?
		notCommand
  end#}}}
	def permitted(method)#{{{
		return (!@sock.user.id.nil? || @permitted.include?(method) || @sock.sockType == SockTypeAnim)
	end#}}}

private

	def notCommand#{{{
    sock.terminal.send 'Huh?' if @sock.sockType == SockTypeUser
	end#}}}
  def moveEarth(sock,dirn,params)#{{{
   if %w{ north south east west }.include?(dirn.downcase)
     coords = Direction.new(sock.user.cube.x,sock.user.cube.y,sock.user.cube.z,dirn).toCoords
     paramstemp = params.split(';').collect{|p| p.split(':') }
     params = {}
     paramstemp.each do |p|
       params[p[0]] = p[1]
     end
     if Cube.zap(coords[0],coords[1],coords[2],params)
       broadcast sock.user.name+" raises a mighty hand toward the "+dirn+", moving earth as music moves its listener.", sock
     else
       sock.terminal.send "But the instrument of earth has been played in this direction."
     end
   end
  end#}}}
  def moveWind(sock,dirn,params)#{{{
   if %w{ up down }.include?(dirn.downcase)
     coords = Direction.new(sock.user.cube.x,sock.user.cube.y,sock.user.cube.z,dirn).toCoords
     paramstemp = params.split(';').collect{|p| p.split(':') }
     params = {}
     paramstemp.each do |p|
       params[p[0]] = p[1]
     end
     if Cube.zap(coords[0],coords[1],coords[2],params)
       broadcast sock.user.name+" stretches mighty lungs and exhales "+dirn+", moving the wind as deftly as an artisan moves a chisel.", sock
     else
       sock.terminal.send "But the instrument of wind has been played in this direction."
     end
   end
  end#}}}
  def moveFire(sock,dirn)#{{{
    coords = Direction.new(sock.user.cube.x,sock.user.cube.y,sock.user.cube.z,dirn).toCoords
    if Cube.raze(coords[0],coords[1],coords[2])
      broadcast sock.user.name+" shines his bright mind "+(%w{up down}.include?(dirn.downcase) ? "toward the " : '')+dirn+" and razes all to annihilation.", sock
    else
      sock.terminal.send "But the instrument of fire has already been played in this direction."
    end
  end#}}}
  def broadcast(str,sock,sendToSelf=true)#{{{
    @allSocks.each do |s|
      s.terminal.send(str) if (s.sockType != SockTypeServ && s.user.sameCubeAs(sock.user.cube) && (sendToSelf || s != sock))
    end
  end#}}}
  def nameUsed?(name)#{{{
    return false if getSockWithName(name).nil?
    return true
  end#}}}
  def getSockWithName(name)#{{{
    @allSocks.each do |s|
      return s if s.user.name == name || s.user.name.sub(' ','_') == name
    end
    return nil
  end#}}}
  def getItem(num)#{{{
    return @sock.user.inventory.getItem(num.to_i - 1) unless @sock.user.inventory.getItem(num.to_i - 1).nil?
    return nil
  end#}}}
  def findSynonym(method)#{{{
    return @@synonyms[method] unless @@synonyms[method].nil?
    return nil
  end#}}}
  def self.addSynonym(realMeth,synonym)#{{{
    @@synonyms[synonym] = realMeth
  end#}}}
end
