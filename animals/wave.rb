class Wave < Animal
	def setStartActions
		@startActions.push "!name a_large_wave"
		@rate = 100
	end

	def shouldAct?
		return (rand(getRate) == 0)
	end

	def getAction
		actions = ["!me crashes","!me crashes, launching salty spray into the wind","!me batters the beach"]
		return actions[rand(actions.size)]
	end
end

