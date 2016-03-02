

class Tile

    @char = nil
    @traversable = nil
    @flavor = nil

    def self.getCharacter
        if (@char.nil?)
            raise Exception::IllegalTileStateException, "#{self.class.name} tile not found."
        end
        @char
    end

    def getCharacter
        if (@char.nil?)
            raise Exception::IllegalTileStateException, "#{self.class.name} tile not found."
        end
        @char
    end

    def isTraversable
        @traversable
    end

    def self.isTraversable
        @traversable
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def getFlavor
        @flavor
    end

    def interacted
        return
    end

    def ontop(entity)
        return
    end

end
