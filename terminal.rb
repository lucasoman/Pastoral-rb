#{{{
=begin
Terminal Management Class

Makes it easier to manage a user terminal without using
another package like Curses.

Written by:
Lucas Oman
2007-09-13
me@lucasoman.com
http://www.lucasoman.com

Because it's so simple, there's little flexibility. Of
course, this may at least put you on the right track if
you're looking to do something else.

Currently, it behaves this way:
Instantiating sends a full blank screen of newlines to the
terminal, clearing the screen and placing the cursor at the
home position of the last line. Afterward, new lines are
added one below the other, starting at the top of the
screen, returning the cursor to its saved position at the
bottom of the screen, even if the user is typing text when the
screen is rewritten. When the screen is full, old lines
scroll off the top of the screen, preserving the last line
as an "input line" for the user.

Send questions, comments, praise and suggestions to the
developer. You're free to use and modify this software.
However, I ask that you 1) leave this entire comment block
in-tact and 2) send me an email, because I get that warm,
prickly feeling inside when I know someone is using my
code.
=end
#}}}

class Terminal
  @@columns = 80
  @@rows = 24

=begin
  sock should be an object of type TCPSocket, or any socket
  that has a member method write(string)
=end
  def initialize(sock)#{{{
    @sock = sock
    clearScreen
    setup
  end#}}}

=begin
  The work horse of this class. Sends str to user terminal.
=end
  def send(str)#{{{
    pushString(str)
    rewriteScreen()
  end#}}}

=begin
  Adds a string to the screen without sending to the user
  terminal. Means user will not see str until screen is
  re-written.
=end
  def pushString(str)#{{{
    lines = str.split("\n")
    lines.each do |l|
      if l.length == 0
        @screen.push ''
      else
        while !l.nil? && l.length > 0
          if l.length <= @@rows
            @screen.push l
            l = ''
          else
            newl = l[0,@@columns]
            @screen.push newl
            l = l.slice @@columns, (l.length - newl.length)
          end
        end
      end
    end
    trimScreen
  end#}}}

=begin
  Rewrites the screen without adding new data to it.
=end
  def rewriteScreen#{{{
    strOut = "\e7" # save cur pos
    (@@rows - 1).times {|n| strOut += "\e[1F\e[2K" } # move up one line, clear line
    strOut += @screen.join("\n")
    (@@rows - 1 - @screen.size).times {|n| strOut+= "\n" }
    strOut += "\e8" # restore saved cur pos
    begin
      @sock.write strOut
    rescue
      @sock.close
      @allSocks.delete @sock
    end
  end#}}}

=begin
  Clears the screen without rewriting it.
=end
  def clearScreen#{{{
    @screen = []
  end#}}}

=begin
  Sends a blank screen to user terminal. It's a good idea
  to do this so that the saved cursor positions are at the
  bottom of the screen.
=end
  def setup#{{{
    str = ''
    (@@rows - 1).times {|n| str += "\n" }
    begin
      @sock.write str
    rescue
      @sock.close
      @allSocks.delete @sock
    end
  end#}}}

  private

=begin
  Removes extra lines (> rows) from screen.
=end
  def trimScreen#{{{
    while @screen.length > (@@rows - 1)
      @screen.shift
    end
  end#}}}
end
