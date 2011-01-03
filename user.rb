class User < Framework
  attr_accessor :cube, :name, :em, :fm, :wm, :sitting, :sitmsg, :inventory, :admin, :id

  def initialize(sock)#{{{
    @cube = Cube.new(0,0,0)
    @name = 'Guest'
    @sock = sock
    @inventory = Inventory.new
    @em = 0
    @fm = 0
    @wm = 0
    @sitting = false
    @sitmsg = ''
  end#}}}
  def identify(user,pass)#{{{
    res = $myDB.query("select id,em,fm,wm,admin from users where username='"+$myDB.escape_string(user)+"' and password=md5('"+$myDB.escape_string(pass)+"')")
    row = res.fetch_hash
    if row.nil?
      @sock.terminal.send "The world does not recognize you as "+user
      return false
    else
			@admin = row['admin']
      @em = row['em']
      @fm = row['fm']
      @wm = row['wm']
			@id = row['id']
			@inventory.userId = @id
			@inventory.addItems Item.loadForUser(@id)
      @sock.terminal.send "The world recognizes you as "+user
      return true
    end
  end#}}}
	def register(user,pass)#{{{
		res = $myDB.query("select id from users where username='"+$myDB.escape_string(user)+"'")
		row = res.fetch_hash
		if !row.nil?
			@sock.terminal.send "Another has already been granted that name."
			return false
		else
			$myDB.query("insert into users set username='"+$myDB.escape_string(user)+"',password=md5('"+$myDB.escape_string(pass)+"')")
			@sock.terminal.send "Granted. You now own the name '"+user+"'"
		end
	end#}}}
  def sameCubeAs(cube)#{{{
    (@cube.x == cube.x && @cube.y == cube.y && @cube.z == cube.z)
  end#}}}
end
