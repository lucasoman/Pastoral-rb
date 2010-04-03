class Pigeon < Animal
  def setStartActions
    @startActions.push "!name a_pigeon"
  end

  def shouldAct?
    return (rand(40) == 0)
  end

  def getAction
    cmds = ["!me coos","!me pecks at seed"]
    cmds[rand(cmds.size)]
  end

  def shouldMove?(dirn)
    false
  end
end
