class Bird < Animal
  def setStartActions
    @startActions.push "!name a_birdie"
		@rate = 40
  end

  def shouldAct?
    return (rand(getRate) == 0)
  end

  def getAction
    cmds = ["!me chirps","!look"]
    num = rand(cmds.size + 1)
    if num == cmds.size
      return "!go "+%w{north south east west up down}[rand(6)]
    else
      return cmds[num]
    end
  end

  def shouldMove?(dirn)
    true
  end
end
