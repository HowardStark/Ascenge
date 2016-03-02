

class Chunk

    @@tag = "Render"

    def initialize
        TurnEvent.getInstance.add_listener self
        Player.getInstance.getLevel.paintLevel
    end

    def turn(*turns)
        Log.v(TurnEvent.tag, "turn event listener has fired with turn #{turns}")
        Player.getInstance.getLevel.paintTiles([
            [Player.getInstance.getPosX,     Player.getInstance.getPosY],
            [Player.getInstance.getPosX - 1, Player.getInstance.getPosY - 2],
            [Player.getInstance.getPosX,     Player.getInstance.getPosY - 2],
            [Player.getInstance.getPosX + 1, Player.getInstance.getPosY - 2],
            [Player.getInstance.getPosX + 2, Player.getInstance.getPosY - 2],
            [Player.getInstance.getPosX - 2, Player.getInstance.getPosY - 1],
            [Player.getInstance.getPosX - 1, Player.getInstance.getPosY - 1],
            [Player.getInstance.getPosX,     Player.getInstance.getPosY - 1],
            [Player.getInstance.getPosX + 1, Player.getInstance.getPosY - 1],
            [Player.getInstance.getPosX + 2, Player.getInstance.getPosY - 1],
            [Player.getInstance.getPosX - 2, Player.getInstance.getPosY],
            [Player.getInstance.getPosX - 1, Player.getInstance.getPosY],
            [Player.getInstance.getPosX + 1, Player.getInstance.getPosY],
            [Player.getInstance.getPosX + 2, Player.getInstance.getPosY],
            [Player.getInstance.getPosX - 2, Player.getInstance.getPosY + 1],
            [Player.getInstance.getPosX - 1, Player.getInstance.getPosY + 1],
            [Player.getInstance.getPosX,     Player.getInstance.getPosY + 1],
            [Player.getInstance.getPosX + 1, Player.getInstance.getPosY + 1],
            [Player.getInstance.getPosX + 2, Player.getInstance.getPosY + 1],
            [Player.getInstance.getPosX - 2, Player.getInstance.getPosY + 2],
            [Player.getInstance.getPosX - 1, Player.getInstance.getPosY + 2],
            [Player.getInstance.getPosX,     Player.getInstance.getPosY + 2],
            [Player.getInstance.getPosX + 1, Player.getInstance.getPosY + 2],
            [Player.getInstance.getPosX + 2, Player.getInstance.getPosY + 2],
        ])
        Curses.setpos(World.getInstance.getStartHeight + Player.getInstance.getPosY, World.getInstance.getStartWidth + Player.getInstance.getPosX)
        Curses.addstr(Player.getInstance.getCharacter)
        Curses.refresh
    end

end
