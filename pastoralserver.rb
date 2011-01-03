class PastoralServer < Framework

  public

  def initialize(address,port)#{{{
    @socket = TCPServer::new(address,port)
    @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    @socket.sockType = SockTypeServ
    @allSocks = []
    @allSocks.push @socket
    @allAnimals = []
    printf("Server started on port %d\n",port)
  end#}}}
  def go#{{{
    # get the animals going
    @allAnimals.each do |a|
      a.startActions.each do |s|
        handle s, a
      end
    end
    while true
      actions = select(@allSocks,nil,nil,1)
      if !actions.nil?
        for sock in actions[0]
          if sock == @socket
            acceptConnection
          else
            if sock.eof?
              sock.close
              @allSocks.delete(sock)
            else
              str = sock.gets.chomp
              handle str, sock
            end
          end
        end
      end
      # check animals for actions
      @allAnimals.each do |a|
        str = a.go
        handle(str,a) unless str.nil?
      end
    end
  end#}}}
  def broadcast(str,sock,sendToSelf=true)#{{{
    @allSocks.each do |s|
      s.terminal.send(str) if (s != @socket && s.user.sameCubeAs(sock.user.cube) && (sendToSelf || s != sock))
    end
  end#}}}
  def getUsersPresent(cube)#{{{
    users = []
    @allSocks.each do |s|
      users.push s.user if s.user.sameCubeAs(cube) && s != @socket
    end
    users
  end#}}}
  def addAnimal(animal)#{{{
    @allAnimals.push animal
  end#}}}

  private

  def acceptConnection#{{{
    newSock = @socket.accept
    newSock.sockType = SockTypeUser
    @allSocks.push newSock
    newSock.terminal.pushString welcomeMessage
    newSock.terminal.pushString Terminal.getLine
    newSock.terminal.send newSock.describeCube
    broadcast "A guest has joined us.",newSock, false
  end#}}}
  def handle(str,sock)#{{{
    $stderr.puts sock.user.name+" ("+sock.user.cube.x.to_s+","+sock.user.cube.y.to_s+","+sock.user.cube.z.to_s+"): "+str+"\n"
    if str.match('^'+$cmdChar)
      sock.terminal.pushString(': '+str)
      tokens = str.sub($cmdChar,'').split(' ')
      handler = Handler.new(sock,tokens,@allSocks)
			begin
				handler.send(tokens[0].to_sym)
			rescue Exception=>msg
				sock.terminal.send('Sorry, there was a problem executing that command.')
				sock.terminal.send(msg.inspect)
				sock.terminal.send(msg.backtrace.inspect)
			end
    else
      str.chomp!
			if str != ""
				sock.terminal.pushString("You say, \""+str+"\e[m\"")
				broadcast sock.user.name+" says, \""+str+"\e[m\"", sock, false
			end
    end
  end#}}}
  def welcomeMessage#{{{
    "\n\n\e[1mWelcome to my \"Pastoral Chat\" server.\e[0m\n\nThis software is still under serious development, so please excuse quirks, bugs, crashes, spontaneous combustion. If you encounter a weird bug, feel free to contact the developer (me@lucasoman.com). Questions, suggestions and praise can be directed there, as well. At any time, type !help for very sparse help info.\n"
  end#}}}
end
