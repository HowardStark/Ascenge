#!/usr/bin/ruby

require 'curses'

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
        Curses.curs_set(0)
        Log.i(@@cursesTag, "Hiding cursor...")
        Curses.init_screen
        Log.i(@@cursesTag, "Initializing Curses screen...")
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

            setTitle("Generating...")
            9.times { |x|
                case x
                when 1
                    @world[x] = OutsideLevel.new
                else
                    @world[x] = GenericLevel.new(x)
                end
            }
            @currentLevel = @world[1]
            @player = Player.getInstance
            Player.getInstance.create(20,20, @world[1])
            chunk = Chunk.new
            Log.d(@@ascengeTag, @world[1])
            TurnEvent.getInstance.turnHappened
            # @world[1].getAreas[0].paint
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

# Look into JSON logging. Credit to @Aidan
# Log levels:
#   debug,
#   warning,
#   error,
#   info,
#   verbose
#   global
#   wtf
module Log extend self

    def d(tag, message)
        log(Log::DEBUG, tag, message)
    end

    def w(tag, message)
        log(Log::WARNING, tag, message)
    end

    def e(tag, message)
        log(Log::ERROR, tag, message)
    end

    def i(tag, message)
        log(Log::INFO, tag, message)
    end

    def v(tag, message)
        log(Log::VERBOSE, tag, message)
    end

    def wtf(tag, message)
        log(Log::WTF, tag, message)
    end

    def add(key,value)
        @hash ||= Hash.new(nil)
        @hash[key] = value
    end

    def const_missing(key)
        @hash[key]
    end

    def each
        @hash.each { |key,value|
            yield(key,value)
        }
    end

    Log.add(:DEBUG, "DEBUG")
    Log.add(:WARNING, "WARNING")
    Log.add(:ERROR, "ERROR")
    Log.add(:INFO, "INFO")
    Log.add(:VERBOSE, "VERBOSE")
    Log.add(:GLOBAL, "GLOBAL")
    Log.add(:WTF, "WTF")

    def log(level, tag, message)
        tag = "[#{tag}]"
        currTime = Time.new.to_i
        yearMonthDayTime = Time.at(currTime).strftime("%Y-%m-%d")
        hourMinuteSecondTime = Time.at(currTime).strftime("%H:%M:%S,%L")
        @logPath = File.expand_path("~/.ascenge/")
        @logDir = Dir.mkdir(@logPath) unless File.exists?(@logPath)
        # Prints out in format of: 2015-12-03 - 12:37:16.000 - INFO - Ascenge - Initializing World...
        output = "#{yearMonthDayTime.ljust(11)}- #{hourMinuteSecondTime.ljust(13)}- #{level.ljust(level.length + 1)}- #{tag.ljust(tag.length + 1)}- #{message}\n"
        File.open(@logPath + "/#{level.downcase}.log", 'a') { |file| file.write(output) }
        File.open(@logPath + "/global.log", 'a') { |file| file.write(output) }
    end

    def global(tag, message)
        level = Log::GLOBAL
        tag = "[#{tag}]"
        currTime = Time.new.to_i
        yearMonthDayTime = Time.at(currTime).strftime("%Y-%m-%d")
        hourMinuteSecondTime = Time.at(currTime).strftime("%H:%M:%S,%L")
        @logPath = File.expand_path("~/.ascenge/")
        @logDir = Dir.mkdir(@logPath) unless File.exists?(@logPath)
        output = "#{yearMonthDayTime.ljust(11)}- #{hourMinuteSecondTime.ljust(13)}- #{level.ljust(level.length + 1)}- #{tag.ljust(tag.length + 1)}- #{message}\n"
        Log.each { |key,value|
            File.open(@logPath + "/#{value.downcase}.log", 'a') { |file| file.write(output) }
        }
    end

    alias :debug :d
    alias :warning :w
    alias :error :e
    alias :info :i
    alias :verbose :v
    private :log

end

class IllegalTileStateException < StandardError
    attr_reader :msg
    def initialize(msg)
        super
        @msg = msg
        @tag = "IllegalTileStateException"
        Log.e(self.class.name, @msg)
    end
end

class IllegalEntityStateException < StandardError
    attr_reader :msg
    def initialize(msg)
        super
        @msg = msg
        Log.e(self.class.name, @msg)
    end
end

class IllegalEntityMovementException < StandardError
    attr_reader :msg
    def initialize(msg)
        super
        @msg = msg
        Log.e(self.class.name, @msg)
    end
end

class IllegalArgumentException < StandardError
    attr_reader :msg
    def initialize(msg)
        super
        @msg = msg
        Log.e(self.class.name, @msg)
    end
end

module Listenable

    def listeners()
        @listeners ||= []
    end

    def add_listener(listener)
        listeners << listener
    end

    def remove_listener(listener)
        listeners.delete listener
    end

    def notify_listeners(event_name, *args)
        Log.d(TurnEvent.tag, "#{event_name} has been notified with #{args}.")
        listeners.each do |listener|
            Log.d(TurnEvent.tag, "#{listener}")
            if listener.respond_to? event_name
                listener.__send__ event_name, *args
            end
        end
    end

end

class TurnEvent
    include Listenable

    @@turns = 0
    @@tag = "TurnEvent"

    def turnHappened
        @@turns+=1
        notify_listeners :turn, @@turns
        Log.v(@@tag, "turn #{@@turns} has happened")
    end

    def self.getInstance
        @@instance ||= TurnEvent.new
    end

    def self.tag
        @@tag
    end

end

class Level

    def initialize()
        @chunks = nil
        @level = nil
        @areas = nil
        @requirements = nil
        @areasnum = nil
    end

    def getLevel
        @level
    end

    def getAreas
        @areas
    end

    def getAreasNum
        @areasnum
    end

    def getTile(x, y)
        Log.d(self.class.name, "Getting tile #{x}, #{y}")
        @areas.each { |area|
            Log.d(self.class.name, area)
            Log.d(self.class.name, area.getBounds)
            if(area.getBounds[0] < x && area.getBounds[2] > x && area.getBounds[1] < y && area.getBounds[3] > y)
                return area.getTile(x, y)
            end
        }
    end

end

class GenericLevel < Level
    def initialize(level)
        @properties = {
            "" => "",
        }
        @areas = Array.new
        @level = level
        @areasnum = Random.rand(4...12)

        @areasnum.times { |x|
            @areas.push(GenericRoom.new(World.getInstance.getWidth / 2 - 5, World.getInstance.getHeight / 2 - 7, World.getInstance.getWidth / 2 + 4, World.getInstance.getHeight / 2 + 8))
        }
    end
end

class FirstLevel < Level
    def initialize
        @level = 1
    end
end

class OutsideLevel < Level
    def initialize
        @properties = {
            "" => "",
        }
        @areas = Array.new
        @level = 0
        @areasnum = 1
        @areas[0] = OutsideArea.new(World.getInstance.getStartWidth, World.getInstance.getStartHeight, World.getInstance.getWidth, World.getInstance.getHeight - 1)

    end
end

class Chunk

    @@tag = "Render"

    def initialize
        TurnEvent.getInstance.add_listener self
    end

    def turn(*turns)
        Log.v(TurnEvent.tag, "turn event listener has fired with turn #{turns}")
        Player.getInstance.getLevel.getAreas.each { |area|
            area.paint
        }
        Curses.setpos(World.getInstance.getStartHeight + Player.getInstance.getPosY, World.getInstance.getStartWidth + Player.getInstance.getPosX)
        Curses.addstr(Player.getInstance.getCharacter)
        Curses.refresh
    end

end

class Area
    def initialize()
        @tiles = Array.new
        @xCoord = nil
        @yCoord = nil
        @xFinish = nil
        @yFinish = nil
        @bounds = [@xCoord, @yCoord, @xFinish, @yFinish]
    end

    def paint()
        @tiles.length.times { |x|
            @tiles[x].length.times { |y|
                Curses.setpos(y + @yCoord,x + @xCoord)
                Curses.addstr(@tiles[x][y].getCharacter)
            }
        }
        Curses.refresh
    end

    def tiles
        @tiles
    end

    def getTile(x, y)
        @tiles[x][y]
    end

    def getBounds
        return [@xCoord, @yCoord, @xFinish, @yFinish]
    end
end

class OutsideArea < Area
    def initialize(xCoord, yCoord, xFinish, yFinish)
        @tiles = Array.new
        @xCoord = xCoord
        @yCoord = yCoord
        @xFinish = xFinish
        @yFinish = yFinish

        length = xFinish - xCoord
        height = yFinish - yCoord

        length.times { |x|
            @tiles[x] = Array.new
            height.times { |y|
                @tiles[x][y] = DirtTile.new
            }
        }
        @tiles[20][21] = WallTile.new

    end
end

class GenericRoom < Area
    def initialize(xCoord, yCoord, xFinish, yFinish)
        @tiles = Array.new

        @xCoord = xCoord
        @yCoord = yCoord
        @xFinish = xFinish
        @yFinish = yFinish

        length = xFinish - xCoord
        height = yFinish - yCoord

        length.times { |x|
            @tiles[x] = Array.new
            height.times { |y|
                if (x == 0 || y == 0 || x == length - 1|| y == height - 1)
                    @tiles[x][y] = WallTile.new
                else
                    @tiles[x][y] = FloorTile.new
                end
            }
        }
    end
end


class Tile
    def initialize()
        @char = nil
        @traversable = nil
    end

    def getCharacter
        if (@char.nil?)
            raise IllegalTileStateException, "#{self.class.name}tile not found."
        end
        @char
    end

    def isTraversable
        @traversable
    end
end

class TreeTile < Tile
    def intitialize
        @char = "T"
        @traversable = false
    end
end

class WallTile < Tile
    def initialize
        @char = "#"
        @traversable = false
    end
end

class FloorTile < Tile
    def initialize
        @char = "-"
        @traversable = true
    end
end

class DirtTile < Tile
    def initialize
        isSpecial = Random.rand(0...6)
        if(isSpecial == 5)
            @char = ","
        else
            @char = "."
        end
        @traversable = true
    end
end

class Entity

    def initialize
        @health = nil
        @speed = nil
        @attack = nil
        @posX = nil
        @posY = nil
        @char = nil
        @state = EntityStates::ENTITY_UNKNOWN
        @level = nil
    end

    def create(x, y, level)
        @posX = x
        @posY = y
        @level = level
    end

    def getPosX
        @posX
    end

    def getPosY
        @posY
    end

    def getHealth
        @health
    end

    def getCharacter
        @char
    end

    def getLevel
        @level
    end

    def setLevel(level)
        @level = level
    end

    def state
        @state
    end

    def move(direction, speed)
        speed.times { |x|
            case direction
            when EntityStates::DIRECTION_DOWN
                if(!@level.getTile(@posX, @posY + direction[1]).isTraversable)
                    World.getInstance.setTitle("There's something in your way!")
                    break
                end
                @posY = @posY + direction[1]
            when EntityStates::DIRECTION_UP
                if(!@level.getTile(@posX, @posY + direction[1]).isTraversable)
                    World.getInstance.setTitle("There's something in your way!")
                    break
                end
                @posY = @posY + direction[1]
            when EntityStates::DIRECTION_LEFT
                if(!@level.getTile(@posX + direction[0], @posY).isTraversable)
                    World.getInstance.setTitle("There's something in your way!")
                    break
                end
                @posX = @posX + direction[0]
            when EntityStates::DIRECTION_RIGHT
                if(!@level.getTile(@posX + direction[0], @posY).isTraversable)
                    World.getInstance.setTitle("There's something in your way!")
                    break
                end
                @posX = @posX + direction[0]
            else
                raise IllegalEntityStateException, "#{direction} is not a valid direction"
            end
        }
    end

end

module EntityStates extend self

    def add(key,value)
        @hash ||= Hash.new { |hash, key|
            raise IllegalEntityStateException, "#{key} is not a valid entity state."
        }
        @hash[key] = value
    end

    def const_missing(key)
        @hash[key]
    end

    def each
        @hash.each { |key,value|
            yield(key,value)
        }
    end

    EntityStates.add(:ENTITY_UNKNOWN, 0)
    EntityStates.add(:ENTITY_SLEEPING, 1)
    EntityStates.add(:ENTITY_ACTIVE, 2)
    EntityStates.add(:ENTITY_FIGHTING, 3)
    EntityStates.add(:ENTITY_HIDDEN, 4)

    EntityStates.add(:DIRECTION_UP, [0, -1])
    EntityStates.add(:DIRECTION_DOWN, [0, 1])
    EntityStates.add(:DIRECTION_LEFT, [-1, 0])
    EntityStates.add(:DIRECTION_RIGHT, [1, 0])
end

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

World.getInstance.start

##
 ##
#.
