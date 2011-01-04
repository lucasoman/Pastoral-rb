class SeaGull < Animal
	def setStartActions
		@startActions.push "!name a_sea_gull"
		@rate = 100
	end

	def shouldAct?
		return (rand(getRate) == 0)
	end

	def getAction
		actions = ["!me screeches","!me swoops"]
		num = rand(actions.size + 1)
		if num == actions.size
			return "!go "+pickAllowedDirection
		else
			return actions[num]
		end
	end
end
