class Crab < Animal
	def setStartActions
		@startActions.push "!name a_small_crab"
		@rate = 100
	end

	def shouldAct?
		return (rand(getRate) == 0)
	end

	def getAction
		actions = ["!me scurries across the sand","!me disappears into his hole","!me appears from a hole in the sand"]
		return actions[rand(actions.size)]
	end
end

