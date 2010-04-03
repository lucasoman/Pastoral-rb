class Animal
  attr_accessor :terminal, :user, :sockType, :startActions
  def setStartActions#{{{
=begin
  Override this method to set commands that should be
  executed on start-up.
=end
    @startActions.push "!name animal"
  end#}}}
  def shouldAct?#{{{
=begin
  Decides frequency of action.
  returns bool
=end
    return (rand(20) == 0)
  end#}}}
  def getAction#{{{
=begin
  Returns an action. Assume that shouldAct? was called to
  decide if an action should be made.
=end
    "!me chirps"
  end#}}}
  def shouldMove?(dirn)#{{{
=begin
  Returns true if the animal should move in that direction,
  false otherwise.
=end
    true
  end#}}}


  # *** Don't override any of the following methods

  def initialize(x=nil,y=nil,z=nil)#{{{
    @startActions = ['!animal 4n1m4l']
    @startActions.push '!transport '+x.to_s+' '+y.to_s+' '+z.to_s if !z.nil?
    @terminal = Terminal.new(self)
    @user = User.new(self)
    @sockType = SockTypeAnim
    setStartActions
  end#}}}
  def go#{{{
    return getAction if shouldAct?
  end#}}}
  def write(str)#{{{
    if str.match('^~')
      tokens = str.split(' ')
      tokens.shift
      tokens = tokens.join(' ').split(':')
      case tokens[0]
        when 'users'
          @users = tokens[1].split(',')
        when 'gotos'
          @gotos = tokens[1].split(',')
        when 'seetos'
          @seetos = tokens[1].split(',')
        when 'coords'
          coords = tokens[1].split(',')
          @x = coords[0]
          @y = coords[1]
          @z = coords[2]
        when 'description'
          @description = tokens[1]
      end
    end
  end#}}}
  def describeCube#{{{
    return user.cube.describeCubeAnimal
  end#}}}
end
