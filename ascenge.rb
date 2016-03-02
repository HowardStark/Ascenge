require "bundler"
Bundler.require

doNotLoad = [
    "#{File.dirname(__FILE__)}/#{__FILE__}"
]

priorityLoad = [
    "#{File.dirname(__FILE__)}/util/Logger.rb",
    "#{File.dirname(__FILE__)}/util/Listenable.rb",
    "#{File.dirname(__FILE__)}/tile/Tile.rb",
    "#{File.dirname(__FILE__)}/world/Level.rb"
]

doNotLoad.each_with_index { |file, index|
    doNotLoad[index] = File.expand_path(file)
}

priorityLoad.each_with_index { |file, index|
    priorityLoad[index] = File.expand_path(file)
    load(priorityLoad[index])
}

Dir[File.expand_path("#{File.dirname(__FILE__)}/**/*.rb")].each { |f|
    if(!doNotLoad.include?(f) && !priorityLoad.include?(f))
        load(f)
    end
}

class World

    @@worldTag = "World"
    @@cursesTag = "Curses"
    @@ascengeTag = "Ascenge "

    @width = nil
    @height = nil

    @publicWidth = nil
    @publicHeight = nil

    @world = nil

    @player = nil

    def start
        Log.global(@@ascengeTag, "----------------")
        Log.global(@@ascengeTag, "ASCENGE STARTING")
        Curses.init_screen
        Log.i(@@cursesTag, "Initializing Curses screen...")
        Curses.curs_set(0)
        Log.i(@@cursesTag, "Hiding cursor...")
        Curses.stdscr.keypad(true)
        Log.i(@@cursesTag, "Enabling keypad...")
        Curses.noecho
        Log.i(@@cursesTag, "Disable output of key presses...")
        Curses.cbreak()
        Log.i(@@cursesTag, "Enable rapid key fetching...")
        begin
            Log.i(@@ascengeTag, "World is initializing")

            @width = Curses.cols
            @height = Curses.lines

            Log.d(@@ascengeTag, "Set private width to #{@width} and private height to #{@height}")
            Log.d(@@ascengeTag, "Set public width to #{@publicWidth} and public height to #{@publicHeight}")

            @world = Hash.new { |hash, key|
                raise InvalidLevelException, "#{key} is not a valid level."
            }

            setTitle("Loading...")
            9.times { |x|
                case x
                when 1
                    @world[x] = OutsideLevel.new
                else
                    @world[x] = GenericLevel.new(x)
                end
            }
            @currentLevel = @world[1]
            setTitle("Level 1")
            chunk = Chunk.new
            Log.d(@@ascengeTag, @world[1])
            TurnEvent.getInstance.turnHappened
            loop {
                keyPressed = Curses.getch
                Log.i(Player.tag, "keypress fired #{keyPressed}")
                case keyPressed
                when "w"
                    Player.getInstance.move(EntityStates::DIRECTION_UP, Player.getInstance.getSpeed)
                when "s"
                    Player.getInstance.move(EntityStates::DIRECTION_DOWN, Player.getInstance.getSpeed)
                when "a"
                    Player.getInstance.move(EntityStates::DIRECTION_LEFT, Player.getInstance.getSpeed)
                when "d"
                    Player.getInstance.move(EntityStates::DIRECTION_RIGHT, Player.getInstance.getSpeed)
                end
            }
        ensure
            Curses.close_screen
        end
    end

    def self.getInstance
        @@instance ||= World.new
    end

    def setTitle(title)
        4.times { |x|
            Curses.setpos(x, 0)
            Curses.clrtoeol
        }
        Curses.setpos(1, (@width / 2) - (title.length / 2))
        Curses.addstr(title)
        Curses.setpos(3, 0)
        seperator = ""
        @width.times { |x|
            seperator = seperator + "#"
        }
        Curses.addstr(seperator)
        Curses.refresh
    end

    def getWorld
        @world
    end

    def getHeight
        @height
    end

    def getCurrentLevel
        @currentLevel
    end

    def getWidth
        @width
    end

    def getStartWidth
        return 0
    end

    def getStartHeight
        return 0 + 4
    end

end

if File.identical?(__FILE__, $0)
  World.getInstance.start
end
