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

    def damage(amount)
        @health = @health - amount
        Log.i(self.class.name, "took damage. Health is at " + getHealth.to_s)
    end

    def move(direction, speed)
        @level.getTile(@posX, @posY).ontop(self)
        speed.times { |x|
            case direction
            when EntityStates::DIRECTION_DOWN
                if(!@level.getTile(@posX, @posY + direction[1]).isTraversable || !@level.isWithinBounds(@posX, @posY + direction[1]))
                    World.getInstance.setTitle(@level.getTile(@posX, @posY + direction[1]).getFlavor)
                    @level.getTile(@posX, @posY + direction[1]).interacted
                    break
                else
                    @level.getTile(@posX, @posY + direction[1]).ontop(self)
                end
                @posY = @posY + direction[1]
            when EntityStates::DIRECTION_UP
                if(!@level.getTile(@posX, @posY + direction[1]).isTraversable || !@level.isWithinBounds(@posX, @posY + direction[1]))
                    World.getInstance.setTitle(@level.getTile(@posX, @posY + direction[1]).getFlavor)
                    @level.getTile(@posX, @posY + direction[1]).interacted
                    break
                else
                    @level.getTile(@posX, @posY + direction[1]).ontop(self)
                end
                @posY = @posY + direction[1]
            when EntityStates::DIRECTION_LEFT
                if(!@level.getTile(@posX + direction[0], @posY).isTraversable || !@level.isWithinBounds(@posX + direction[0], @posY))
                    World.getInstance.setTitle(@level.getTile(@posX + direction[0], @posY).getFlavor)
                    @level.getTile(@posX + direction[0], @posY).interacted
                    break
                else
                    @level.getTile(@posX + direction[0], @posY).ontop(self)
                end
                @posX = @posX + direction[0]
            when EntityStates::DIRECTION_RIGHT
                if(!@level.getTile(@posX + direction[0], @posY).isTraversable || !@level.isWithinBounds(@posX + direction[0], @posY))
                    World.getInstance.setTitle(@level.getTile(@posX + direction[0], @posY).getFlavor)
                    @level.getTile(@posX + direction[0], @posY).interacted
                    break
                else
                    @level.getTile(@posX + direction[0], @posY).ontop(self)
                end
                @posX = @posX + direction[0]
            else
                raise IllegalEntityStateException, "#{direction} is not a valid direction"
            end
        }
    end

end
