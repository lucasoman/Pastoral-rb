class Deer < Animal
  def setStartActions
    @startActions.push "!name "+%w{a_fawn a_doe a_stag}[rand(3)]
		@directions = %w{north south east west}
		2.times do
			@directions.push @directions[rand(4)]
		end
		@rate = 40
  end

  def shouldAct?
    return (rand(getRate) == 0)
  end

  def getAction
    cmds = ["!me grazes silently","!look"]
    num = rand(cmds.size + 1)
    if num == cmds.size
      return "!go "+@directions[rand(@directions.size)]
    else
      return cmds[num]
    end
  end
end
