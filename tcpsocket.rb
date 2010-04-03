SockTypeServ = 0
SockTypeUser = 1
SockTypeAnim = 2

class TCPSocket
  attr_accessor :sockType

  def user
    @user = User.new(self) if @user.nil?
    @user
  end

  def user=(newuser)
    @user = newuser
  end

  def terminal
    @terminal = Terminal.new(self) if @terminal.nil?
    @terminal
  end

  def terminal=(newTerm)
    @terminal = newTerm
  end

  def describeCube
    return user.cube.describeCube if sockType == SockTypeUser
    return user.cube.describeCubeAnimal if sockType == SockTypeAnim
  end
end
