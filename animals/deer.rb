class Deer < Animal
  def setStartActions
    @startActions.push "!name a_deer"
  end

  def shouldAct?
    return (rand(25) == 0)
  end

  def getAction
    cmds = ["!me grazes silently","!look"]
    num = rand(cmds.size + 1)
    if num == cmds.size
      return "!go "+%w{north south east west}[rand(4)]
    else
      return cmds[num]
    end
  end
end
