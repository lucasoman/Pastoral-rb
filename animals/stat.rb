class Stat < Animal
  def setStartActions
    @startActions.push "!name stat_bot"
		@state = 'asleep'
		@map = {}
		@stats = {}
		@outputPath = '/var/www/map/'
		@rate = 1
  end

  def shouldAct?
    return (rand(getRate) > 1)
  end

  def getAction
		if @state == 'asleep'
			@state = 'crawling'
			@toStat = []
			crawl(0,0,0)
			@state = 'stats'
			return '!me writes some numbers on a piece of paper'
		elsif @state == 'stats'
			if @toStat.size > 0
				@state = 'statting'
				@statting = @toStat.shift
				return '!stat '+@statting
			else
				@state = 'done'
				return 'Done.'
			end
		elsif @state == 'done'
			@state = 'asleep'
			@rate = 1
			draw
			@map = {}
			return '!me folds the paper and puts it into his pocket'
		elsif @state == 'statting'
			return '!me thinks'
		end
  end

  def shouldMove?(dirn)
    true
  end

	def crawl(x,y,z)
		print("Crawling: "+[x,y,z].collect{|i|i.to_s}.join(',')+"\n")
		cube = Cube.new(x,y,z)
		return if !cube.exists? || (!@map[z].nil? && !@map[z][x].nil? && !@map[z][x][y].nil?)

		@toStat.push cube.x.to_s+' '+cube.y.to_s+' '+cube.z.to_s
		@map[z] = {} if @map[z].nil?
		@map[z][x] = {} if @map[z][x].nil?
		@map[z][x][y] = cube
		cube.seetos.each do |g|
			crawl(g['x'],g['y'],g['z'])
		end
	end

	def draw
		@map.each do |num,level|
			drawLevel(level,@outputPath+'map'+num.to_s+'.html')
		end
	end

	def drawLevel(level,file)
		minx = maxx = miny = maxy = 0
		level.each do |x,col|
			minx = x.to_i if x.to_i < minx
			maxx = x.to_i if x.to_i > maxx
			col.each do |y,junk|
				miny = y.to_i if y.to_i < miny
				maxy = y.to_i if y.to_i > maxy
			end
		end
		styles = '<style>
td {
	font-size:8px;
	border: solid 1px #C0C0C0;
	text-align: center;
}
table {
	border: solid 1px #C0C0C0;
}
</style>'
		str = styles+'<table cellpadding="0" cellspacing="0">'
		for reversey in 0..(maxy - miny)
			y = maxy - reversey
			str += '<tr>'
			for x in minx..maxx
				if level[x.to_s].nil? || level[x.to_s][y.to_s].nil?
					innards = ''
				else
					cube = level[x.to_s][y.to_s]
					if cube.exists?
						stats = @stats[[cube.x.to_s,cube.y.to_s,cube.z.to_s].join(' ')]
						innards = [cube.x,cube.y,cube.z].join(',')+"<img src=\"cube"+[cube.x,cube.y,cube.z].join('_')+".png\" width=\"40\" height=\"40\" title=\""+cube.distant_description+"\n\n"+cube.description+"\"/>"+[stats['users'].size,stats['animals'].size].join(',')
					else
						innards = ''
					end
				end
				str += '<td width="50" height="50">'+innards+'</td>'
			end
			str += '</tr>'
		end
		File.open(file,'w') {|f| f.write(str) }
	end

	def getStats(cube)
		@cube = cube
		@next = cube.x.to_s+' '+cube.y.to_s+' '+cube.z.to_s
	end
	
	def write(str)
		str.split("\n").each do |line|
			if line.match('^# ')
				tokens = line.strip.split(' ')
				tokens.shift
				tokens = tokens.join(' ').split(':')
				case tokens[0]
					when 'users'
						if !tokens[1].nil?
							@users = tokens[1].split(',')
						else
							@users = ''
						end
					when 'animals'
						if !tokens[1].nil?
							@animals = tokens[1].split(',')
						else
							@animals = ''
						end
						@state = 'stats'
						@stats[@statting] = {'users'=>@users,'animals'=>@animals}
				end
			end
		end
	end
end

