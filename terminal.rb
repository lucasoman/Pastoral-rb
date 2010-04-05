class Terminal

=begin
  sock should be an object of type TCPSocket, or any socket
  that has a member method write(string)
=end
  def initialize(sock)#{{{
    @sock = sock
  end#}}}

=begin
  Adds a string to the screen without sending to the user
  terminal. Means user will not see str until screen is
  re-written.
=end
  def pushString(str)#{{{
		send(str)
  end#}}}

=begin
  Rewrites the screen without adding new data to it.
=end
  def send(strOut)#{{{
		strOut += "\n"
    begin
      @sock.write strOut
    rescue
      @sock.close
      @allSocks.delete @sock
    end
  end#}}}

  def self.getLine#{{{
    desc = "\n"
    79.times { desc += "~" }
    desc += "\n\n"
    desc
  end#}}}
end
