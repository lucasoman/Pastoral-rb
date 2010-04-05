class Direction
	attr_reader :fromX,:fromY,:fromZ,:toDirn,:fromDirn,:toX,:toY,:toZ,:fromCoords,:toCoords

	def initialize(x,y,z,dirn)#{{{
		@fromX = x
		@fromY = y
		@fromZ = z
		@toDirn = dirn

		@fromDirn = Direction.oppositeDirn(@toDirn)
		(@toX,@toY,@toZ) = Direction.dirnToCoords(@fromX,@fromY,@fromZ,@toDirn)
		@fromCoords = [@fromX,@fromY,@fromZ]
		@toCoords = [@toX,@toY,@toZ]
	end#}}}
	def self.fromCoords(x,y,z,tx,ty,tz)#{{{
		self.new(x,y,z,self.coordsToDirn(x,y,z,tx,ty,tz))
	end#}}}

	def self.coordsToDirn(fx,fy,fz,tx,ty,tz)#{{{
		fx = fx.to_i
		fy = fy.to_i
		fz = fz.to_i
		tx = tx.to_i
		ty = ty.to_i
		tz = tz.to_i
		if (fx - tx == -1) then str = 'East'
		elsif (fx - tx == 1) then str = 'West'
		elsif (fy - ty == -1) then str = 'North'
		elsif (fy - ty == 1) then str = 'South'
		elsif (fz - tz == -1) then str = 'Up'
		elsif (fz - tz == 1) then str = 'Down'
		else str = false
		end
		str
	end#}}}
	def self.dirnToCoords(x,y,z,dirn)#{{{
		case dirn.downcase
			when 'east'
				x = x + 1
			when 'west'
				x = x - 1
			when 'north'
				y = y + 1
			when 'south'
				y = y - 1
			when 'up'
				z = z + 1
			when 'down'
				z = z - 1
		end
		[x,y,z]
	end#}}}
	def self.oppositeDirn(dirn)#{{{
		{'east'=>'west','west'=>'east','north'=>'south','south'=>'north','up'=>'down','down'=>'up'}[dirn.downcase]
	end#}}}
end
