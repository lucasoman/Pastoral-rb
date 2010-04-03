class User < Framework
  attr_accessor :cube, :name, :em, :fm, :wm, :sitting, :sitmsg, :inventory

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
    res = $myDB.query("select em,fm,wm from users where username='"+$myDB.escape_string(user)+"' and password=md5('"+$myDB.escape_string(pass)+"')")
    row = res.fetch_hash
    if row.nil?
      @sock.terminal.send "The world does not recognize you as "+user
      return false
    else
      @em = row['em']
      @fm = row['fm']
      @wm = row['wm']
      @sock.terminal.send "The world recognizes you as "+user
      return true
    end
  end#}}}
  def sameCubeAs(cube)#{{{
    (@cube.x == cube.x && @cube.y == cube.y && @cube.z == cube.z)
  end#}}}
end
