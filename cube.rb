class Cube < Framework
  attr_accessor :description, :gotos, :seetos, :distant_description, :x, :y, :z
  public

  def initialize(x,y,z)#{{{
    @x = x
    @y = y
    @z = z
    @gotos = []
    @seetos = []
    res = $myDB.query("select description,distant_description,id from cubes where x='"+$myDB.escape_string(x.to_s)+"' and y='"+$myDB.escape_string(y.to_s)+"' and z='"+$myDB.escape_string(z.to_s)+"'")
    row = res.fetch_hash
    if row.nil?
      @exists = false
      return
    else
      @exists = true
    end

    @description = row['description']
    @distant_description = row['distant_description']
    @id = row['id']

    res = $myDB.query("select x1,y1,z1,x2,y2,z2 from goto_link where
     (x1='"+$myDB.escape_string(@x.to_s)+"'
     and y1='"+$myDB.escape_string(@y.to_s)+"'
     and z1='"+$myDB.escape_string(@z.to_s)+"')
     or (x2='"+$myDB.escape_string(@x.to_s)+"'
     and y2='"+$myDB.escape_string(@y.to_s)+"'
     and z2='"+$myDB.escape_string(@z.to_s)+"')
     ")
    while row = res.fetch_hash
      if row['x1'] == @x.to_s && row['y1'] == @y.to_s && row['z1'].to_s == @z.to_s
        tx = row['x2']
        ty = row['y2']
        tz = row['z2']
      else
        tx = row['x1']
        ty = row['y1']
        tz = row['z1']
      end
      gotores = $myDB.query("select distant_description,x,y,z from cubes where x='"+$myDB.escape_string(tx)+"' and y='"+$myDB.escape_string(ty)+"' and z='"+$myDB.escape_string(tz)+"'")
      @gotos.push gotores.fetch_hash
    end

    res = $myDB.query("select x1,y1,z1,x2,y2,z2 from seeto_link where
     (x1='"+$myDB.escape_string(@x.to_s)+"'
     and y1='"+$myDB.escape_string(@y.to_s)+"'
     and z1='"+$myDB.escape_string(@z.to_s)+"')
     or (x2='"+$myDB.escape_string(@x.to_s)+"'
     and y2='"+$myDB.escape_string(@y.to_s)+"'
     and z2='"+$myDB.escape_string(@z.to_s)+"')
     ")
    while row = res.fetch_hash
      if row['x1'] == @x.to_s && row['y1'] == @y.to_s && row['z1'] == @z.to_s
        tx = row['x2']
        ty = row['y2']
        tz = row['z2']
      else
        tx = row['x1']
        ty = row['y1']
        tz = row['z1']
      end
      seetores = $myDB.query("select distant_description,x,y,z from cubes where x='"+$myDB.escape_string(tx)+"' and y='"+$myDB.escape_string(ty)+"' and z='"+$myDB.escape_string(tz)+"'")
      @seetos.push seetores.fetch_hash
    end
  end#}}}
  def exists?#{{{
    return @exists
  end#}}}
	def goToDirn?(dirn)#{{{
		coords = Direction.new(@x,@y,@z,dirn).toCoords
		@gotos.each do |g|
			return true if g['x'].to_i == coords[0].to_i && g['y'].to_i == coords[1].to_i && g['z'].to_i == coords[2].to_i
		end
		false
	end#}}}
  def changeCube(dirn)#{{{
    coords = Direction.new(@x,@y,@z,dirn).toCoords
    Cube.new(coords[0],coords[1],coords[2])
  end#}}}
  def describeCube#{{{
    desc = ''
    desc += description.to_s+"\n\n"
    desc += describeUsersPresent
    desc += describeSeetos
    desc += describeGotos
    desc
  end#}}}
  def describeCubeAnimal#{{{
    desc = ''
    desc += '~ coords:'+[@x,@y,@z].join(',')+"\n"
    desc += '~ description:'+description.to_s+"\n"
    desc += '~ users:'+describeUsersPresent(true)+"\n"
    desc += '~ seetos:'+describeSeetos(true)+"\n"
    desc += '~ gotos:'+describeGotos(true)
    desc
  end#}}}
	def describeStats
		str = ''
		str += '# users:'+describeUsersPresent(true)+"\n"
		str += '# animals:'+describeAnimalsPresent
		str
	end
  def Cube.zap(x,y,z,params)#{{{
    newCube = Cube.new(x,y,z)
    if newCube.exists?
      return false
    else
      newCube.description = params['description']
      newCube.distant_description = params['distant_description']
      if !params['seetos'].nil?
        params['seetos'].split(',').each do |s|
          newCube.addSeeto Direction.new(x,y,z,s).toCoords
        end
      end
      if !params['gotos'].nil?
        params['gotos'].split(',').each do |g|
          newCube.addGoto Direction.new(x,y,z,g).toCoords
        end
      end
      newCube.save
      return true
    end
  end#}}}
  def Cube.raze(x,y,z)#{{{
    oldCube = Cube.new(x,y,z)
    if oldCube.exists?
      oldCube.destroy
      return true
    else
      return false
    end
  end#}}}
  def save#{{{
    $myDB.query("insert into cubes set
     description='"+$myDB.escape_string(@description)+"',
     distant_description='"+$myDB.escape_string(@distant_description)+"',
     x='"+$myDB.escape_string(@x.to_s)+"',
     y='"+$myDB.escape_string(@y.to_s)+"',
     z='"+$myDB.escape_string(@z.to_s)+"'
     ")
    @gotos.each do |g|
      $myDB.query("insert into goto_link set
       x1='"+$myDB.escape_string(@x.to_s)+"',
       y1='"+$myDB.escape_string(@y.to_s)+"',
       z1='"+$myDB.escape_string(@z.to_s)+"',
       x2='"+$myDB.escape_string(g['x'].to_s)+"',
       y2='"+$myDB.escape_string(g['y'].to_s)+"',
       z2='"+$myDB.escape_string(g['z'].to_s)+"'")
    end
    @seetos.each do |s|
      $myDB.query("insert into seeto_link set
       x1='"+$myDB.escape_string(@x.to_s)+"',
       y1='"+$myDB.escape_string(@y.to_s)+"',
       z1='"+$myDB.escape_string(@z.to_s)+"',
       x2='"+$myDB.escape_string(s['x'].to_s)+"',
       y2='"+$myDB.escape_string(s['y'].to_s)+"',
       z2='"+$myDB.escape_string(s['z'].to_s)+"'")
    end
  end#}}}
  def destroy#{{{
    $myDB.query("delete from cubes where id='"+$myDB.escape_string(@id.to_s)+"'")
    $myDB.query("delete from goto_link where
     (x1='"+$myDB.escape_string(@x.to_s)+"'
     and y1='"+$myDB.escape_string(@y.to_s)+"'
     and z1='"+$myDB.escape_string(@z.to_s)+"')
     or (x2='"+$myDB.escape_string(@x.to_s)+"'
     and y2='"+$myDB.escape_string(@y.to_s)+"'
     and z2='"+$myDB.escape_string(@z.to_s)+"')
     ")
    $myDB.query("delete from seeto_link where
     (x1='"+$myDB.escape_string(@x.to_s)+"'
     and y1='"+$myDB.escape_string(@y.to_s)+"'
     and z1='"+$myDB.escape_string(@z.to_s)+"')
     or (x2='"+$myDB.escape_string(@x.to_s)+"'
     and y2='"+$myDB.escape_string(@y.to_s)+"'
     and z2='"+$myDB.escape_string(@z.to_s)+"')
     ")
  end#}}}
  def addGoto(coords)#{{{
    @gotos.push({ 'x' => coords[0], 'y' => coords[1], 'z' => coords[2] })
  end#}}}
  def addSeeto(coords)#{{{
    @seetos.push({ 'x' => coords[0], 'y' => coords[1], 'z' => coords[2] })
  end#}}}

  private

  def describeSeetos(animal=false)#{{{
    str = '' if !animal
    dirns = [] if animal
    @seetos.each do |s|
      dirn = Direction.fromCoords(@x,@y,@z,s['x'],s['y'],s['z']).toDirn
      str += "\e[1mYou can see "+dirn+":\e[m "+s['distant_description']+"\n" if !animal
      dirns.push(dirn) if animal
    end
    return str if !animal
    return dirns.join(',') if animal
  end#}}}
  def describeGotos(animal=false)#{{{
    dirns = []
    @gotos.each do |s|
      dirns.push Direction.fromCoords(@x,@y,@z,s['x'],s['y'],s['z']).toDirn
    end
    return "\e[1mYou can go "+dirns.join(', ')+"\e[m" if !animal
    return dirns.join(',') if animal
  end#}}}
  def describeUsersPresent(animal=false)#{{{
    users = $myServer.getUsersPresent(self)
    str = '' if !animal
    usrs = [] if animal
    str = "\e[1mThere are some people milling about:\e[m\n" if !users.empty? && !animal
    users.each do |u|
      perms = []
      perms.push 'E' if u.em == '1'
      perms.push 'F' if u.fm == '1'
      perms.push 'W' if u.wm == '1'
      sittingmsg = (u.sitting ? ' [sitting'+(u.sitmsg != '' ? ' '+u.sitmsg : '')+']' : '')
      str += (perms.size > 0 ? '['+perms.join('')+'] ' : '')+u.name+sittingmsg+"\n" if !animal
      usrs.push(u.name) if animal
    end
    return str if !animal
    return usrs.join(',') if animal
  end#}}}
	def describeAnimalsPresent#{{{
		animals = $myServer.getAnimalsPresent(self)
		animals.collect{|a| a.name}.join(',')
	end#}}}
end
