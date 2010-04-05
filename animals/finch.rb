class Finch < Animal
  def setStartActions
    @startActions.push "!name a_finch"
  end

  def shouldAct?
    return (rand(80) == 0)
  end

  def getAction
    cmds = ["!me chirps","!me pecks at seed"]
    cmds[rand(cmds.size)]
  end

  def shouldMove?(dirn)
    false
  end
end
