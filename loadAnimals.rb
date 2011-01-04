# global
3.times do
  $myServer.addAnimal(Bird.new)
  $myServer.addAnimal(Deer.new)
end


# bird bath in square
$myServer.addAnimal(Pigeon.new(0,-1,0))
$myServer.addAnimal(Finch.new(0,-1,0))


# beach
3.times do
	gull = SeaGull.new(1,6,0)
	gull.allowedCubes = [
				[1,5,0],
				[1,6,0],
				[2,6,0]
			]
	$myServer.addAnimal(gull)
end
$myServer.addAnimal(Wave.new(1,6,0))
$myServer.addAnimal(Wave.new(2,6,0))
$myServer.addAnimal(Crab.new(2,6,0))
