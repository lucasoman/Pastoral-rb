class Pigeon < Animal
  def setStartActions
    @startActions.push "!name a_pigeon"
		@rate = 80
  end

  def shouldAct?
    return (rand(getRate) == 0)
  end

  def getAction
    cmds = ["!me coos","!me pecks at seed"]
    cmds[rand(cmds.size)]
  end

  def shouldMove?(dirn)
    false
  end
end
