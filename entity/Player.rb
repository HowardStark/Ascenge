class Player < Entity

    @@tag = "Player"

    def initialize
        @health = 10.0
        @speed = 1
        @attack = 1
        @char = "@"
        @state = EntityStates::ENTITY_ACTIVE
    end

    def listenInput
        loop {
            keyPressed = Curses.getch
            Log.i(@@tag, "keypress fired #{keyPressed}")
            case keyPressed
            when "w"
                Player.getInstance.move(EntityStates::DIRECTION_UP, @speed)
            when "s"
                Player.getInstance.move(EntityStates::DIRECTION_DOWN, @speed)
            when "a"
                Player.getInstance.move(EntityStates::DIRECTION_LEFT, @speed)
            when "d"
                Player.getInstance.move(EntityStates::DIRECTION_RIGHT, @speed)
            end
        }
    end

    def move(direction, speed)
        super
        Log.d(TurnEvent.tag, "player moved #{direction}")
        TurnEvent.getInstance.turnHappened
    end

    def self.getInstance
        @@instance ||= Player.new
    end

    def getSpeed
        @speed
    end

    def self.tag
        @@tag
    end

end
